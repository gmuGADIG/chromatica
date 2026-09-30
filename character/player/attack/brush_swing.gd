extends Node2D
class_name PlayerBrush
@export var player : Player
@export var player_movement : PlayerMovement
@export_group("Dimentions")
@export var brush_width : float = 256
@export var brush_length : float = 256
@export_group("Timing")

##The time (in seconds) that the brush hitbox exists
@export var swing_duration: float = 0.1
##The time (in seconds) that the brush is on cooldown after swinging
@export var swing_recovery: float = 0.3
@export var swing_buffer_time : float = 0.3
@export_group("Properties")
#change to a longer time when find out what durration should be
@export var brush_damage : int = 2

##Used to avoid double hitting entities & objects within a single swing
var hit_things : Array[Variant]

@onready var attack_area : Area2D = $AttackArea
@onready var brush_shape : RectangleShape2D = $AttackArea/CollisionShape2D.shape
@onready var swing_timer : Timer = $SwingDuration
@onready var buffer_timer : Timer = $SwingBuffer
@onready var recovery_timer : Timer = $SwingRecovery

func _ready() -> void:
	attack_area.area_entered.connect(_on_area_entered)
	
	swing_timer.wait_time = swing_duration
	recovery_timer.wait_time = swing_recovery
	buffer_timer.wait_time = swing_buffer_time
	
	swing_timer.timeout.connect(end_swing)
	recovery_timer.timeout.connect(
		func() -> void: 
			player.state = Player.State.NONE
	)

func _input(event: InputEvent):
	if event.is_action_pressed("brush_swing"):
		var swung : bool = try_swing()
		if not swung:
			buffer_timer.start()

func _process(delta: float) -> void:
	if not buffer_timer.is_stopped() and player.state == Player.State.NONE:
		buffer_timer.stop()
		try_swing()


func try_swing() -> bool:
	if not player.state == Player.State.NONE:
		return false
	
	if player.is_on_floor() and Input.is_action_pressed("look_up"):
		brush_vertical()
		swing_brush(180*Vector2.UP)
	elif not player.is_on_floor() and Input.is_action_pressed("look_down"):
		brush_vertical()
		swing_brush(180*Vector2.DOWN)
	else:
		brush_horizontal()
		var dir : Vector2 = Vector2(player_movement.last_horizontal_direction,0).normalized()
		swing_brush(100*dir)
	return true

func brush_horizontal() -> void:
	brush_shape.size = Vector2(brush_length,brush_width)

func brush_vertical() -> void:
	brush_shape.size = Vector2(brush_width,brush_length)

func swing_brush(dir : Vector2) -> void:
	hit_things.clear()
	player.state = Player.State.BRUSH_SWING
	#maybe wepon move
	attack_area.position = dir
	attack_area.monitoring = true
	attack_area.show()
	swing_timer.start()


func end_swing() -> void:
	attack_area.monitoring = false
	attack_area.hide()
	recovery_timer.start()

func _on_area_entered(area: Area2D) -> void:
	if hit_things.has(area):
		return
	
	if area is EnemyHitbox:
		area.hit(DamageInfo.new(brush_damage,DamageInfo.AttackColor.RED))
		hit_things.append(area)
