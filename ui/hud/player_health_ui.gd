extends Node

# This script should be attached to the container that holds the hit points.

# The individual hitpoint prefab
@export var healthElementScene: PackedScene

# The health component that contains the signals and hp variable
# As PlayerHealthComponent extends HelathComponent, this should workn with that code
@export var player_health: HealthComponent

# Array to store the health elements for later access
var hit_points: Array[HealthElement]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Instantiates health relative to max hp and adds them to an array
	# Array is used for accessing the individual health elements
	for i in range(player_health.maximum_hp):
		var healthElementInstance = healthElementScene.instantiate()
		add_child(healthElementInstance)
		hit_points.append(healthElementInstance)
		
	# Connects the heath_changed signal from player_health to the code
	# On recieving, calls changeHealth with the signal's argument
	player_health.health_changed.connect(changeHealth)

# Called when the health_changed signal is emitted by player_health
# Calls revoke or grant to modify the number of health icons shown
# If new health is 0, use the health_depleted signal instead
func changeHealth(newHealth: int):
	# First statement is called when the player loses health
	if newHealth < player_health.hp:
		for i in range(player_health.hp - newHealth):
			hit_points[player_health.hp - (i + 1)].revoke()
			
	elif newHealth > player_health.hp:
		for i in range(newHealth - player_health.hp):
			hit_points[player_health.hp + i].grant()
		
