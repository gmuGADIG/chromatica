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
	if (!pips[0].visible and !pips[1].visible):
		pips[0].self_modulate = colorable_component.colors[0]
		pips[0].show()
	
	elif (!pips[1].visible):
		pips[1].self_modulate = colorable_component.colors[1]
		pips[1].show()
	
	else:
		pips[0].self_modulate = colorable_component.colors[0]
		pips[1].self_modulate = colorable_component.colors[1]
	
	pass

# made this just in case varnish needs to be done on the UI end because the tasklist details
# show that when varnish is applied, the ui disappears again so the player can apply new colors
func varnished() -> void:
	pips[0].hide()
	pips[1].hide()
