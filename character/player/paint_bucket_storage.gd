class_name PaintBucketStorage
extends Node

@export var starting_max_paint_buckets : int
var max_paint_buckets : int
var current_paint_buckets : int
@export var bucket_heal_amount : int
@export var player_health : HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(player_health)
	max_paint_buckets = starting_max_paint_buckets
	Progression.collected_bead.connect(set_max_paint_buckets)

func set_max_paint_buckets() -> void:
	max_paint_buckets = starting_max_paint_buckets + (Progression.beads_collected[Bead.BeadType.BUCKET_SLOT])/2
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("use_paint_bucket") and current_paint_buckets > 0:
		var extra_heal = (Progression.beads_collected[Bead.BeadType.BUCKET_HEALING]/2) / 2
		player_health.heal(bucket_heal_amount + extra_heal)
		current_paint_buckets -= 1
		print(current_paint_buckets)
		print(player_health.hp)

func add_paint_bucket():
	current_paint_buckets += 1
	if current_paint_buckets > max_paint_buckets:
		current_paint_buckets = max_paint_buckets
