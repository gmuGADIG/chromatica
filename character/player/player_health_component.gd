extends HealthComponent

class_name PlayerHealthComponent

static var maximum_hp_player: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.Health.maxiumum_hp = maximum_hp_player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
