extends Control
@onready var file_select: FileSelect = $FileSelect
@onready var main_menu : Control = $MainMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	file_select.closed.connect(_on_file_select_closed)
	main_menu.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_file_select_closed() -> void:
	file_select.hide()
	main_menu.show()
	

func _on_button_main_start_pressed() -> void:
	file_select.show()
	main_menu.hide()
	

func _on_button_main_quit_pressed() -> void:
	get_tree().quit()
