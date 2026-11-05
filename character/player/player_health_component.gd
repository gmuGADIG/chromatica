extends HealthComponent

class_name PlayerHealthComponent

static var maximum_hp_player: int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(Progression)
	Progression.collected_bead.connect(_on_bead_collect)
	maximum_hp = maximum_hp_player
	reset_health()

func _on_bead_collect(bead : Bead.BeadType, new_amount : int) -> void:
	if bead == Bead.BeadType.HIT_POINTS:
		##TODO
		pass
