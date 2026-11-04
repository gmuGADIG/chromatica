extends ProgressBar

# A reference to the player's health
@export var player_health: HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	self.value =  player_health.hp
	self.max_value = player_health.maximum_hp
	
	# Connects the heath_changed signal from player_health to the code
	# On recieving, calls changeHealth with the signal's argument
	player_health.health_changed.connect(changeHealth)
	
# Called when the health_changed signal is emitted by player_health
# Calls here update the bar percentage to reflect the new player health
# If new health is 0, use the health_depleted signal instead
func changeHealth(newHealth: int):

	# First statement is called when the player loses health
	self.value = newHealth
