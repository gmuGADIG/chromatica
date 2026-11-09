extends HealthComponent

class_name PlayerHealthComponent

static var maximum_hp_player: int = 3

##Shows the vignette when the player is below this % HP
@export var vignette_treshold : float = 34.0
@export var vignette : Vignette 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(Progression)
	Progression.collected_bead.connect(_on_bead_collect)
	maximum_hp = maximum_hp_player
	reset_health()

func hurt(amount : int) -> void:
	super.hurt(amount)
	_update_vignette()
	

func heal(amount : int) -> void:
	super.heal(amount)
	_update_vignette()

func _update_vignette() -> void:
	if not vignette:
		return
	vignette.visible = hp/maximum_hp <= 0.01*vignette_treshold

func _on_bead_collect(bead : Bead.BeadType, new_amount : int) -> void:
	if bead == Bead.BeadType.HIT_POINTS:
		##TODO
		pass
