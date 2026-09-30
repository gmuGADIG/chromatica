extends Control
@onready var file_select: FileSelect = $FileSelect
@onready var settings_menu: SettingsMenu = $SettingsMenu
@onready var main_menu : Control = $MainMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	file_select.closed.connect(_on_file_select_closed)
	settings_menu.closed.connect(_on_settings_closed)
	open()
	
	#this demo button is temp and just exists to flex stuff in build showcases
	$MainMenu/DemoButton.pressed.connect(_on_demobutton_pressed)

func open():
	$MainMenu/Start.grab_focus()
	main_menu.show()

func _on_file_select_closed() -> void:
	file_select.hide()
	main_menu.show()

func _on_settings_closed() -> void:
	settings_menu.hide()
	main_menu.show()
	
func _on_button_main_start_pressed() -> void:
	main_menu.hide()
	file_select.open()
	
func _on_button_main_quit_pressed() -> void:
	get_tree().quit()

func _on_settings_pressed():
	main_menu.hide()
	settings_menu.open()

# When the main menu is opened, let's focus the keyboard/controllers on the start button.
func _on_main_menu_visibility_changed():
	if not is_node_ready(): return
	if main_menu.visible: $MainMenu/Start.grab_focus()

# TODO this is just there to have somewhere to demo the CSV parser!
func _on_demobutton_pressed() -> void:
	get_tree().change_scene_to_file("res://temp/test_csvparser.tscn")
