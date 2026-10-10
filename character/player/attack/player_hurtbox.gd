@tool
class_name PlayerHurtbox extends Area2D

signal finished

@export var player : Player
@export var collision_shape : CollisionShape2D

@export_group("Dimensions")
@export var hurtbox_shape : Vector2 = Vector2(256,256):
	set(val):
		hurtbox_shape = val
		_update_hurtbox_shape()
@export var offset : Vector2 = Vector2(128,0):
	set(val):
		offset = val
		_update_hurtbox_shape()

@export_group("Timing")
##The time (in seconds) that the hitbox exists
@export var swing_duration: float = 0.1

@export_group("Debug")
@export_enum("Left:180","Right:0","Up:270","Down:90") var attack_direction: int:
	set(val):
		attack_direction = val
		rotation_degrees = val
@onready var rect_shape : RectangleShape2D = $CollisionShape2D.shape
@onready var attack_timer := $SwingDuration as Timer

##Used to avoid double hitting entities & objects within a single swing
var hit_things : Array[Variant]
## Caches the last attack direction to reattempt the attack during buffer.
var last_attack_dir : Vector2

## Informs the parent attack script about which enemy to damage.
signal enemy_hit(enemy: EnemyHitbox)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	area_entered.connect(_on_area_entered)	
	attack_timer.wait_time = swing_duration
	
	attack_timer.timeout.connect(end_attack)

func start_attack(dir: Vector2) -> void:
	if dir.is_equal_approx(Vector2.RIGHT):
		rotation_degrees = 0
	elif dir.is_equal_approx(Vector2.DOWN):
		rotation_degrees = 90
	elif dir.is_equal_approx(Vector2.LEFT):
		rotation_degrees = 180
	elif dir.is_equal_approx(Vector2.UP):
		rotation_degrees = 270
	else:
		printerr("Invalid attack direction")
	
	hit_things.clear()
	monitoring = true
	show()
	attack_timer.start()

func end_attack() -> void:
	monitoring = false
	hide()
	finished.emit()

func _on_area_entered(area: Area2D) -> void:
	if hit_things.has(area):
		return
	
	if area is EnemyHitbox:
		enemy_hit.emit(area)
		hit_things.append(area)

func _update_hurtbox_shape() -> void:
	collision_shape.shape.size = hurtbox_shape
	collision_shape.position = offset
