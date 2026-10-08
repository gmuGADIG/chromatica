class_name Paint
extends Object

# Hue enum with all primary and secondary colors
enum Hue
{
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
