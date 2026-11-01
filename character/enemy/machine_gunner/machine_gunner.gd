## NOTE! 
## This is a prototype enemy who's purpose is to demonstrate programing potential.
## This enemy was not part of Ayame's pitch nor the design team's concept.
## This entity should not be present in the base game scenes unless specified.

extends GroundEnemy
class_name MachineGunner
## Patrols. When it sees the player it stops, winds up its gun (the telegraph),
## then sprays bullets for a few seconds while slowly tracking the player.
## After the burst it's stuck recovering, which is the player's window to hit it.
##
## PATROL -> CHARGE -> FIRE -> RECOVER -> (CHARGE again if it still sees you, else PATROL)

enum State { PATROL, CHARGE, FIRE, RECOVER }

@export_group("Gun")
## The node that rotates. Its barrel should point along +X at rotation 0.
@export var cannon : Node2D
## Where bullets spawn (child of the cannon)
@export var muzzle : Marker2D
## Needs a launch(direction: Vector2) method (see Cannonball)
@export var bullet_scene : PackedScene

@export_group("Charge")
## Seconds spent winding up before the burst. This is the player's warning.
@export var charge_time : float = 1.2
## How fast the gun turns toward the player while charging (radians/sec)
@export var charge_turn_speed : float = 4.0
## The gun fades to this color while charging, and stays this color while firing
@export var charge_color : Color = Color(1.0, 0.3, 0.2)
## How hard the gun shakes at full charge (px)
@export var charge_shake : float = 4.0
## Seconds without sight of the player before it gives up the charge
@export var lose_sight_time : float = 1.0

@export_group("Firing")
## How long the burst lasts (sec)
@export var fire_duration : float = 2.5
## Bullets per second
@export var shots_per_second : float = 12.0
## How fast the gun turns while firing (radians/sec). Keep low so the player can dodge.
@export var fire_turn_speed : float = 1.0
## Random aim wobble on each bullet (degrees, +/-)
@export var spread_degrees : float = 4.0
## Seconds it's stuck still after the burst
@export var recover_time : float = 1.5

@export_group("Sight")
## Physics layers that block line of sight. Include the player's layer
## (it's checked for explicitly, so it doesn't count as blocking).
@export_flags_2d_physics var sight_mask : int = 3

var state : State = State.PATROL

var _timer : float = 0.0
var _lost_sight : float = 0.0
var _shot_charge : float = 0.0
var _cannon_rest_position : Vector2 = Vector2.ZERO


func _ready() -> void:
	super()
	if cannon == null or muzzle == null or bullet_scene == null:
		push_warning("MachineGunner '%s' is missing its cannon, muzzle, or bullet_scene." % name)
	if cannon:
		_cannon_rest_position = cannon.position


func _think(delta: float) -> void:
	match state:
		State.PATROL:
			patrol(delta)
			_rotate_cannon_toward(0.0 if facing > 0 else PI, charge_turn_speed, delta)
			if can_see_player():
				_enter(State.CHARGE, charge_time)

		State.CHARGE:
			accelerate_toward(0.0, delta)
			if can_see_player():
				_lost_sight = 0.0
				var target := get_player_center()
				face(dir_to(target.x))
				_rotate_cannon_toward(_angle_to(target), charge_turn_speed, delta)
			else:
				_lost_sight += delta
				if _lost_sight >= lose_sight_time:
					_enter(State.PATROL, 0.0)
					return
			_timer -= delta
			_apply_charge_tell(1.0 - clampf(_timer / maxf(charge_time, 0.001), 0.0, 1.0))
			if _timer <= 0.0:
				_enter(State.FIRE, fire_duration)

		State.FIRE:
			accelerate_toward(0.0, delta)
			# Committed to the burst: keeps firing even if the player ducks out of sight
			if get_player() != null:
				var target := get_player_center()
				face(dir_to(target.x))
				_rotate_cannon_toward(_angle_to(target), fire_turn_speed, delta)
			_shot_charge += delta * shots_per_second
			while _shot_charge >= 1.0:
				_shot_charge -= 1.0
				attack()
			_timer -= delta
			if _timer <= 0.0:
				_enter(State.RECOVER, recover_time)

		State.RECOVER:
			accelerate_toward(0.0, delta)
			_timer -= delta
			if _timer <= 0.0:
				if can_see_player():
					_enter(State.CHARGE, charge_time)
				else:
					_enter(State.PATROL, 0.0)


## Fires ONE bullet in the direction the gun is pointing (with a little spread).
## The FIRE state calls this repeatedly.
func attack() -> void:
	if bullet_scene == null or muzzle == null or cannon == null:
		return
	var bullet := bullet_scene.instantiate() as Cannonball
	get_parent().add_child(bullet)
	bullet.global_position = muzzle.global_position
	var spread := deg_to_rad(randf_range(-spread_degrees, spread_degrees))
	bullet.launch(Vector2.RIGHT.rotated(cannon.global_rotation + spread))


## Needs an unobstructed line from the cannon to the player, within sight_range.
func can_see_player() -> bool:
	var player := get_player()
	if player == null:
		return false
	var target := get_player_center()
	var origin := cannon.global_position if cannon else global_position
	if origin.distance_to(target) > sight_range:
		return false

	var query := PhysicsRayQueryParameters2D.create(origin, target, sight_mask, [get_rid()])
	var result := get_world_2d().direct_space_state.intersect_ray(query)
	return result.is_empty() or result["collider"] == player


## Stop glowing/shaking if the enemy is turned friendly mid-attack.
func become_friendly() -> void:
	super()
	_reset_tell()


func _enter(new_state: State, duration: float) -> void:
	state = new_state
	_timer = duration
	_lost_sight = 0.0
	match new_state:
		State.FIRE:
			_shot_charge = 1.0 # first bullet leaves immediately
			_reset_tell()
			if cannon:
				cannon.modulate = charge_color
		State.CHARGE:
			pass # _apply_charge_tell drives the visuals
		_:
			_reset_tell()


func _apply_charge_tell(progress: float) -> void:
	if cannon == null:
		return
	cannon.modulate = Color.WHITE.lerp(charge_color, progress)
	cannon.position = _cannon_rest_position + Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * charge_shake * progress


func _reset_tell() -> void:
	if cannon == null:
		return
	cannon.modulate = Color.WHITE
	cannon.position = _cannon_rest_position


func _angle_to(world_position: Vector2) -> float:
	var origin := cannon.global_position if cannon else global_position
	return (world_position - origin).angle()


func _rotate_cannon_toward(angle: float, turn_speed: float, delta: float) -> void:
	if cannon == null:
		return
	var step := turn_speed * delta
	cannon.global_rotation += clampf(angle_difference(cannon.global_rotation, angle), -step, step)
