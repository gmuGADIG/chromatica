class_name Paint
extends Object

# Hue enum with all primary and secondary colors
enum Hue
{
	NONE,
	RED,
	YELLOW,
	BLUE,
	ORANGE,
	GREEN,
	PURPLE
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
			printerr("Invalid Color Provided")
			return Color.BLACK

static func get_color_mix(hue1 : Hue, hue2: Hue) -> Hue:
	var comboValue: int = Hue.values().find(hue1) + Hue.values().find(hue2)
	match comboValue:
		(Hue.RED + Hue.BLUE):
			return Hue.PURPLE
		(Hue.RED + Hue.YELLOW):
			return Hue.ORANGE
		(Hue.BLUE + Hue.YELLOW):
			return Hue.GREEN
		_:
			printerr("Invalid color combo!")
			return Hue.NONE
	return Hue.NONE
