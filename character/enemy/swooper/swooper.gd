## NOTE! 
## This is a prototype enemy who's purpose is to demonstrate programing potential.
## This enemy was not part of Ayame's pitch nor the design team's concept.
## This entity should not be present in the base game scenes unless specified.

extends AirEnemy
class_name Swooper
## Lives in the background. Lurks (small, dim, can't be hit), stalks the player,
## telegraphs a dive, then swoops in a U-shaped arc through the player's position.
## For a moment mid-swoop it's in the play plane: full size, hittable, and it hurts.
## Then it climbs back into the background and lurks again.
##
## The "background" is faked with depth: scale, tint, z_index, and by switching the
## hitbox / hurtbox on only while the enemy is in the play plane.
##
## LURK -> STALK -> TELEGRAPH -> SWOOP -> LURK
##
## The body collides with nothing (collision_mask = 0): it's flying behind the level,
## so it passes through walls and floors on purpose.

enum State { LURK, STALK, TELEGRAPH, SWOOP }

## z_index switches between background and foreground once depth crosses this
const Z_SWITCH_DEPTH : float = 0.5

@export_group("Lurk")
## How far from its home point it drifts while lurking (px)
@export var home_radius : float = 250.0
## Drift speed while lurking (px/sec)
@export var idle_speed : float = 100.0
## Seconds between picking new drift points
@export var wander_interval : float = 2.0
## Seconds after a swoop before it can start another
@export var attack_cooldown : float = 3.0
## (It notices the player within sight_range, from AirEnemy. Walls don't block it,
## since it's in the background.)

@export_group("Depth")
## Node holding all the art. This is what gets scaled / tinted / shaken.
@export var visual : Node2D
## Scale when fully in the background (1.0 = same size as the play plane)
@export var depth_scale : float = 0.45
## Tint when fully in the background (use alpha to fade it)
@export var background_tint : Color = Color(0.45, 0.5, 0.6, 0.7)
## z_index while in the background. Must draw BEHIND your level tiles but
## in FRONT of your parallax background.
@export var background_z_index : int = -5
## z_index while in the play plane
@export var foreground_z_index : int = 0
## At or below this depth (0 = play plane, 1 = deep background) it can hit and be hit
@export_range(0.0, 1.0) var plane_threshold : float = 0.2
## How fast it fades back into the background outside of a swoop (depth/sec)
@export var depth_change_speed : float = 2.0
## Damages the player during the swoop. Starts disabled; it's only live in the play plane.
@export var contact_hurtbox : EnemyHurtbox

@export_group("Stalk")
## Speed while lining up the dive (px/sec)
@export var stalk_speed : float = 450.0
## Where it lines up, relative to the player's center. x mirrors to whichever
## side the enemy is already on; y is height (negative = above).
@export var launch_offset : Vector2 = Vector2(450.0, -300.0)
## How close to the launch point counts as lined up (px)
@export var stalk_arrive_distance : float = 60.0
## Starts the telegraph after this long even if it hasn't reached the launch point (sec)
@export var stalk_timeout : float = 3.0
## It gives up if the player gets farther than sight_range times this
@export var give_up_multiplier : float = 1.5

@export_group("Telegraph")
## Seconds it hovers and shows the dive path before swooping. The path locks in
## when the telegraph starts, so the player can dodge it.
@export var telegraph_time : float = 0.8
## How hard it shakes at the end of the telegraph (px)
@export var telegraph_shake : float = 5.0
## It fades to this color during the telegraph
@export var telegraph_color : Color = Color(1.0, 0.35, 0.3)
## z_index of the dive-path preview line (should be in front of everything)
@export var preview_z_index : int = 10

@export_group("Swoop")
## Seconds for the whole pass: dive, cross the player, climb away
@export var swoop_duration : float = 1.1
## Fraction of the pass it stays fully in the play plane around the bottom of the arc.
## Bigger = longer window where it's dangerous AND hittable.
@export_range(0.0, 0.9) var plane_window : float = 0.25

var state : State = State.LURK
## 0 = in the play plane, 1 = deep in the background
var depth : float = 1.0

var _timer : float = 0.0
var _cooldown : float = 1.0 # short grace period at spawn
var _wander_timer : float = 0.0
var _home : Vector2 = Vector2.ZERO
var _side : int = 1
var _in_plane : bool = false
var _visual_rest_position : Vector2 = Vector2.ZERO
var _hurtbox_shape : CollisionShape2D
var _preview : Line2D

# Swoop path: one quadratic bezier that passes exactly through the player's position
var _swoop_start : Vector2 = Vector2.ZERO
var _swoop_control : Vector2 = Vector2.ZERO
var _swoop_end : Vector2 = Vector2.ZERO
var _swoop_t : float = 0.0


func _ready() -> void:
	super()
	if visual == null or contact_hurtbox == null:
		push_error("Swooper '%s' needs its visual and contact_hurtbox assigned." % name)
		set_physics_process(false)
		return
	collision_mask = 0 # flies behind the level, collides with nothing
	_home = global_position
	_visual_rest_position = visual.position
	_hurtbox_shape = contact_hurtbox.get_node("CollisionShape2D") as CollisionShape2D

	_preview = Line2D.new()
	_preview.top_level = true # points are in world space
	_preview.width = 6.0
	_preview.default_color = Color(1.0, 0.3, 0.25, 0.5)
	_preview.z_index = preview_z_index
	_preview.visible = false
	add_child(_preview)

	_apply_depth(true)


func _think(delta: float) -> void:
	_cooldown = maxf(_cooldown - delta, 0.0)

	match state:
		State.LURK:
			_approach_depth(1.0, delta)
			_wander_timer -= delta
			if _wander_timer <= 0.0:
				_pick_wander_point()
			fly_toward_target(idle_speed, delta)
			if _cooldown <= 0.0 and can_see_player():
				_start_stalk()

		State.STALK:
			_approach_depth(1.0, delta)
			if _player_too_far():
				_enter_lurk(false)
				return
			var launch := _launch_point()
			set_target(launch)
			fly_toward_target(stalk_speed, delta)
			_timer -= delta
			if global_position.distance_to(launch) <= stalk_arrive_distance or _timer <= 0.0:
				_start_telegraph()

		State.TELEGRAPH:
			_approach_depth(1.0, delta)
			accelerate_toward(Vector2.ZERO, delta)
			_timer -= delta
			_apply_telegraph_tell(1.0 - clampf(_timer / maxf(telegraph_time, 0.001), 0.0, 1.0))
			if _timer <= 0.0:
				attack()

		State.SWOOP:
			_update_swoop(delta)


## Starts the swoop along the path planned when the telegraph began.
func attack() -> void:
	state = State.SWOOP
	_swoop_t = 0.0
	has_target = false
	_preview.hide()
	_reset_tell()


## It notices the player within sight_range. Walls don't matter: it's in the background.
func can_see_player() -> bool:
	var p := get_player()
	return p != null and global_position.distance_to(get_player_center()) <= sight_range


## If the enemy is turned friendly mid-swoop, drop everything and show up as a normal
## foreground character. (The base class already disables its hurtboxes.)
func become_friendly() -> void:
	super()
	if visual == null:
		return
	visual.scale = Vector2.ONE
	visual.modulate = Color.WHITE
	visual.position = _visual_rest_position
	z_index = foreground_z_index
	_preview.hide()


func _enter_lurk(start_cooldown: bool) -> void:
	state = State.LURK
	has_target = false
	_wander_timer = 0.0
	if start_cooldown:
		_cooldown = attack_cooldown
	_preview.hide()
	_reset_tell()


func _start_stalk() -> void:
	state = State.STALK
	_timer = stalk_timeout
	# Stay on the side of the player it's already on so it doesn't cut through them
	_side = int(signf(global_position.x - get_player_center().x))
	if _side == 0:
		_side = 1


func _start_telegraph() -> void:
	state = State.TELEGRAPH
	_timer = telegraph_time
	has_target = false
	_plan_swoop()
	_preview.show()


## Locks the dive path through where the player is standing right now.
## With start S, end E (S mirrored across the player) and control C directly
## below the player at the same distance, the curve passes exactly through the player.
func _plan_swoop() -> void:
	var target := get_player_center()
	_swoop_start = global_position
	_swoop_end = Vector2(2.0 * target.x - _swoop_start.x, _swoop_start.y)
	_swoop_control = Vector2(target.x, 2.0 * target.y - _swoop_start.y)

	var points := PackedVector2Array()
	for i in 25:
		points.append(_bezier(_swoop_start, _swoop_control, _swoop_end, i / 24.0))
	_preview.points = points


func _update_swoop(delta: float) -> void:
	_swoop_t = minf(_swoop_t + delta / maxf(swoop_duration, 0.01), 1.0)
	var pos := _bezier(_swoop_start, _swoop_control, _swoop_end, _swoop_t)
	# Driven through velocity so AirEnemy's move_and_slide() does the actual moving
	velocity = (pos - global_position) / delta

	# Deepest at both ends of the pass, fully in the play plane around the middle
	var from_middle := absf(_swoop_t - 0.5) * 2.0
	depth = smoothstep(plane_window, 1.0, from_middle)
	_apply_depth()

	if _swoop_t >= 1.0:
		velocity = velocity.limit_length(max_velocity)
		_enter_lurk(true)


## Moves depth toward a value, and updates the visuals and hitboxes to match.
func _approach_depth(target_depth: float, delta: float) -> void:
	depth = move_toward(depth, target_depth, depth_change_speed * delta)
	_apply_depth()


func _apply_depth(force: bool = false) -> void:
	visual.scale = Vector2.ONE * lerpf(1.0, depth_scale, depth)
	visual.modulate = Color.WHITE.lerp(background_tint, depth)
	z_index = foreground_z_index if depth < Z_SWITCH_DEPTH else background_z_index

	var in_plane := depth <= plane_threshold
	if force or in_plane != _in_plane:
		_in_plane = in_plane
		_set_in_plane(in_plane)


## In the play plane: the player can hit it and it can hit the player.
## In the background: neither.
func _set_in_plane(in_plane: bool) -> void:
	if hitbox:
		hitbox.set_deferred("monitorable", in_plane)
	if health_bar:
		health_bar.visible = in_plane
	# Disabling the shape (instead of monitoring) keeps the hurtbox's cooldown ticking
	_hurtbox_shape.set_deferred("disabled", not in_plane)


func _apply_telegraph_tell(progress: float) -> void:
	visual.modulate = background_tint.lerp(telegraph_color, progress)
	visual.position = _visual_rest_position + Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * telegraph_shake * progress
	_preview.modulate = Color(1.0, 1.0, 1.0, progress)


func _reset_tell() -> void:
	visual.position = _visual_rest_position


func _launch_point() -> Vector2:
	return get_player_center() + Vector2(_side * launch_offset.x, launch_offset.y)


func _player_too_far() -> bool:
	var p := get_player()
	return p == null or global_position.distance_to(get_player_center()) > sight_range * give_up_multiplier


func _pick_wander_point() -> void:
	var offset := Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * home_radius
	set_target(_home + offset)
	_wander_timer = wander_interval * randf_range(0.7, 1.3)


static func _bezier(a: Vector2, b: Vector2, c: Vector2, t: float) -> Vector2:
	return a.lerp(b, t).lerp(b.lerp(c, t), t)
