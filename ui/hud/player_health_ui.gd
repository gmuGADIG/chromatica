extends Node

# This script should be attached to the container that holds the hit points.

# The individual hitpoint prefab
@export var healthElementScene: PackedScene

@export var player_health: HealthComponent

var hit_points: Array[HealthElement]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(player_health.maximum_hp):
		var healthElementInstance = healthElementScene.instantiate()
		add_child(healthElementInstance)

# TODO get signals from HealthComponent, use them to manage HP

		
