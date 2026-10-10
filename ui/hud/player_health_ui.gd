extends Node

# This script should be attached to the container that holds the hit points.

# The individual hitpoint prefab
@export var healthElementScene: PackedScene

# The health component that contains the signals and hp variable
# As PlayerHealthComponent extends HelathComponent, this should workn with that code
@export var player_health: HealthComponent

# Array to store the health elements for later access
var hit_points: Array[HealthElement] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Already wired by an export or a parent scene
	if player_health:
		setup(player_health)
		return
	# Otherwise find the player at runtime (wait a frame so it exists)
	await get_tree().process_frame
	var player := get_tree().get_first_node_in_group("player")
	if player:
		var health := player.get_node_or_null("PlayerHealthComponent") as HealthComponent
		if health:
			setup(health)
			return
	push_warning("PlayerHealthUI: couldn't find the player's health component")

func setup(health: HealthComponent) -> void:
	player_health = health
	# Instantiates health relative to max hp and adds them to an array
	# Array is used for accessing the individual health elements
	for i in range(player_health.maximum_hp):
		var element := healthElementScene.instantiate() as HealthElement
		add_child(element)
		hit_points.append(element)
	# Connects the heath_changed signal from player_health to the code
	# On recieving, calls changeHealth with the signal's argument
	player_health.health_changed.connect(changeHealth)

# Called when the health_changed signal is emitted by player_health
# Calls revoke or grant to modify the number of health icons shown
# If new health is 0, use the health_depleted signal instead
func changeHealth(newHealth: int) -> void:
	
	for i in hit_points.size():
		# First statement is called when the player gains health
		# Second statement is called when the player loses health
		if i < newHealth:
			hit_points[i].grant()
		else:
			hit_points[i].revoke()
	
	print("health changed: ", newHealth)
		
