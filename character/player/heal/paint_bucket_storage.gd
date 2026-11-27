class_name PaintBucketStorage
extends Node2D

@export var player : Player
@export var player_health : HealthComponent
@export var heal_timer : Timer
@export var heal_shader : Sprite2D
@export var heal_particles : CPUParticles2D

@export_group("Paramters")
@export var starting_max_paint_buckets : int = 5
@export var base_bucket_heal_amount : int = 5
@export var heal_duration : float = 1.0

var max_paint_buckets : int
var current_paint_buckets : int



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#await get_tree().process_frame
	heal_shader.hide()
	print(player_health)
	max_paint_buckets = starting_max_paint_buckets
	Progression.collected_bead.connect(set_max_paint_buckets)
	heal_timer.timeout.connect(_heal)
	heal_shader.material.set_shader_parameter("heal_duration",heal_duration)

func set_max_paint_buckets() -> void:
	max_paint_buckets = starting_max_paint_buckets + (Progression.beads_collected[Bead.BeadType.BUCKET_SLOT])/2

func _input(event: InputEvent) -> void:
	if event.is_action_released("use_paint_bucket") and heal_timer.time_left > 0:
		heal_timer.stop()
		_exit_heal()
		

func _process(delta: float) -> void:
	#print(heal_timer.time_left)
	if heal_timer.time_left > 0:
		heal_shader.material.set_shader_parameter("time",heal_duration - heal_timer.time_left)
	
	if Input.is_action_pressed("use_paint_bucket"):
		var has_bucket := current_paint_buckets > 0
		#print(has_bucket)
		var correct_state := player.state == Player.State.NONE
		var grounded := player.is_on_floor()
		if has_bucket and correct_state and grounded:
			player.state = Player.State.HEALING
			heal_timer.start(heal_duration)
			heal_shader.show()
			heal_shader.material.set_shader_parameter("time",0.0)
			heal_shader.material.set_shader_parameter("seed",randf())
			#var start_time : float = mat.get_shader_parameter("TIME")
			
		

func _heal() -> void:
	var extra_heal = (Progression.beads_collected[Bead.BeadType.BUCKET_HEALING]/2) / 2
	player_health.heal(base_bucket_heal_amount + extra_heal)
	current_paint_buckets -= 1
	heal_particles.emitting = true
	_exit_heal()

func _exit_heal() -> void:
	heal_shader.hide()
	player.state = Player.State.NONE

func add_paint_bucket():
	current_paint_buckets += 1
	if current_paint_buckets > max_paint_buckets:
		current_paint_buckets = max_paint_buckets
