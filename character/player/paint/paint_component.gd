class_name Paint
extends Node

# Hue enum with all primary and secondary colors
enum Hue
{
	RED,
	YELLOW,
	BLUE,
	ORANGE,
	GREEN,
	PURPLE,
}

# static function to map Hue to built in color
static func get_color(hue : Hue) -> Color:
	match hue:
		Hue.RED:
			return Color.RED
		Hue.YELLOW:
			return Color.YELLOW
		Hue.BLUE:
			return Color.BLUE
		Hue.ORANGE:
			return Color.ORANGE
		Hue.GREEN:
			return Color.GREEN
		Hue.PURPLE:
			return Color.PURPLE
		_:
			return Color.RED


# selected hue that can only be a primary color
@export var selected_hue : Hue = Hue.RED:
	set(hue):
		if hue == Hue.RED or hue == Hue.YELLOW or hue == Hue.BLUE:
			selected_hue = hue
		else:
			pass
	get:
		return selected_hue;

# array of primary colors that the selected hue can be
# will likley later be replaced with an array of the colors the player has unlocked
var selectable_hues : Array = [Hue.RED,Hue.YELLOW,Hue.BLUE]
var current_hue : int = 0

func _ready() -> void:
	selected_hue = selectable_hues[current_hue]

# the player can cycle through the colors they have unlocked
# the controls should use one or two buttons to cycle through colors
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next_color"):
		current_hue += 1
		if current_hue >= selectable_hues.size():
			current_hue = 0
		selected_hue = selectable_hues[current_hue]
