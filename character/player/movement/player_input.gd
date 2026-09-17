extends Node

func GetDirection() -> float:
	return Input.get_axis("ui_left", "ui_right")
