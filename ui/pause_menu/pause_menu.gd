extends Control

@export var settings_menu: SettingsMenu
@export var pause_panel: Control

func _ready() -> void:
	settings_menu.hide()
	pause_panel.hide()
	
	settings_menu.closed.connect(show_pause_menu)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		# Hitting pause on the pause screen should unpause, of course
		if pause_panel.visible:
			unpause()
		# But hitting pause on the settings menu should just return to the pause menu.
		elif settings_menu.visible:
			show_pause_menu()
		# And if neither of those are the case, we must be unpaused, so let's pause.
		else:
			pause()
		
# This is separate from show_pause_menu. To explain why:
# We might want to only do something only when first pausing, not when going settings->pause 
# Example: Playing a pause sound only here, so it doesn't repeat when you never actually unpaused.
func pause() -> void:
	show_pause_menu()
	get_tree().paused = true

func unpause() -> void:
	settings_menu.hide()
	pause_panel.hide()
	get_tree().paused = false

func show_pause_menu() -> void:
	settings_menu.hide()
	pause_panel.show()
	$PausePanel/VBoxContainer/ResumeButton.grab_focus()
	
func show_settings() -> void:
	settings_menu.open()
	pause_panel.hide()

func _on_settings_button_pressed() -> void:
	show_settings()
	
func _on_resume_button_pressed():
	unpause()
	
func _on_quit_button_pressed():
	# Never forget to unpause the tree before changing scenes!
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")
