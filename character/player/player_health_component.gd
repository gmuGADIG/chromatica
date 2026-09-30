extends HealthComponent

class_name PlayerHealthComponent

static var maximum_hp_player: int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	maximum_hp = maximum_hp_player
	reset_health()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
