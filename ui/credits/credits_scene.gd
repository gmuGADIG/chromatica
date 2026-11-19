extends Control
class_name Credits

@export var scrollSpeed = 70
@export var scrollEnd = 300

var resetPosition

signal closed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resetPosition = $HBoxContainer.position.y
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(visible):
		$HBoxContainer.position.y -= scrollSpeed * delta
		if($EndLogo.position.y > scrollEnd):
			$EndLogo.position.y -= scrollSpeed * delta

func open() -> void:
	show()


func _on_button_pressed() -> void:
	closed.emit()
	$HBoxContainer.position.y = resetPosition
	$EndLogo.position.y = resetPosition + 450
