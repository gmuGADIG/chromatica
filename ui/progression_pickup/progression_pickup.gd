extends Node

@export var unlock_panel : Control
@export var unlock_text_element : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Progression.unlocked_item.connect(on_item_unlock)
	pass # Replace with function body.


func on_item_unlock(unlock : Progression.Unlockable):
	var unlock_text
	match unlock:
		Progression.Unlockable.RED_COLOR:
			unlock_text = "you unocked the red color"
		Progression.Unlockable.YELLOW_COLOR:
			unlock_text = "you unlocked the yellow color"
		Progression.Unlockable.BLUE_COLOR:
			unlock_text = "you unlocked the blue color"
	unlock_text_element.text = unlock_text
	unlock_panel.show()

func _input(event: InputEvent) -> void:
	unlock_panel.hide()
