extends HBoxContainer

@export var colorable_component : Colorable

@onready var pips : Array[ColorablePip] = [$Pip, $Pip2]

func _ready() -> void:
	colorable_component.color_changed.connect(color_updated)
	colorable_component.combo_triggered.connect(varnished)
	$Pip.hide()
	$Pip2.hide()
	pass

func color_updated() -> void:
	var num_colors : int = colorable_component.colors.size()
	
	for i in pips.size():
		if i < num_colors:
			pips[i].modulate = get_color_from_attackcolors(colorable_component.colors[i])
			pips[i].show()
		else:
			pips[i].hide()

func get_color_from_attackcolors(color: DamageInfo.AttackColor) -> Color:
	match color:
		DamageInfo.AttackColor.RED:
			return Color.RED
		DamageInfo.AttackColor.YELLOW:
			return Color.YELLOW
		DamageInfo.AttackColor.BLUE:
			return Color.BLUE
		DamageInfo.AttackColor.ORANGE:
			return Color.ORANGE
		DamageInfo.AttackColor.GREEN:
			return Color.GREEN
		DamageInfo.AttackColor.PURPLE:
			return Color.PURPLE
		_:
			printerr("DamageInfo Attack Color unknown!")
			return Color.WHITE

# made this just in case varnish needs to be done on the UI end because the tasklist details
# show that when varnish is applied, the ui disappears again so the player can apply new colors
func varnished() -> void:
	pips[0].hide()
	pips[1].hide()
