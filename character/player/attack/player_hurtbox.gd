class_name PlayerHurtbox extends Area2D

@export var player : Player

@export_group("Timing")
##The time (in seconds) that the hitbox exists
@export var swing_duration: float = 0.1
##The time (in seconds) that the attack is on cooldown
@export var swing_recovery: float = 0.3
## The time (in seconds) that an attack will register after input
@export var swing_buffer_time : float = 0.3

@onready var collision_shape := $CollisionShape2D.shape as RectangleShape2D
@onready var attack_timer := $SwingDuration as Timer
@onready var buffer_timer := $SwingBuffer as Timer
@onready var recovery_timer := $SwingRecovery as Timer

##Used to avoid double hitting entities & objects within a single swing
var hit_things : Array[Variant]
## Caches the last attack direction to reattempt the attack during buffer.
var last_attack_dir : Vector2

## Informs the parent attack script about which enemy to damage.
signal enemy_hit(enemy: EnemyHitbox)

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

func _process(delta: float) -> void:
	if not buffer_timer.is_stopped() and player.state == Player.State.NONE:
		buffer_timer.stop()
		start_attack(last_attack_dir)

func start_attack(dir: Vector2) -> void:
	if not player.state == Player.State.NONE:
		last_attack_dir = dir
		buffer_timer.start()
		return

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

func set_size(size: Vector2) -> void:
	collision_shape.size = size

func _on_area_entered(area: Area2D) -> void:
	if hit_things.has(area):
		return
	
	if area is EnemyHitbox:
		enemy_hit.emit(area)
		hit_things.append(area)
