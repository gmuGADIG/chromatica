extends Area2D

@export var player : Player

@export_group("Timing")

##The time (in seconds) that the brush hitbox exists
@export var swing_duration: float = 0.1
##The time (in seconds) that the brush is on cooldown after swinging
@export var swing_recovery: float = 0.3
@export var swing_buffer_time : float = 0.3

@onready var collision_shape : RectangleShape2D = $AttackArea/CollisionShape2D.shape
@onready var attack_timer : Timer = $SwingDuration
@onready var buffer_timer : Timer = $SwingBuffer
@onready var recovery_timer : Timer = $SwingRecovery

##Used to avoid double hitting entities & objects within a single swing
var hit_things : Array[Variant]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)	
	attack_timer.wait_time = swing_duration
	recovery_timer.wait_time = swing_recovery
	buffer_timer.wait_time = swing_buffer_time
	
	attack_timer.timeout.connect(end_attack)
	recovery_timer.timeout.connect(
		func() -> void: 
			player.state = Player.State.NONE)

func start_attack(dir: Vector2) -> void:
	hit_things.clear()
	#maybe wepon move
	position = dir
	monitoring = true
	show()
	attack_timer.start()

func end_attack() -> void:
	monitoring = false
	hide()
	recovery_timer.start()

func start_buffer() -> void:
	buffer_timer.start()

func stop_buffer() -> void:
	buffer_timer.stop()

func set_size(size: Vector2) -> void:
	collision_shape.size = size

func _on_area_entered(area: Area2D) -> void:
	if hit_things.has(area):
		return
	
	if area is EnemyHitbox:
		area.hit(DamageInfo.new(brush_damage,DamageInfo.AttackColor.RED))
		hit_things.append(area)
