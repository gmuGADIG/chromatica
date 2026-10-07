extends Control

class_name SettingsMenu

signal closed

func open() -> void:
	%BackButton.grab_focus()
	show()

func _on_button_pressed() -> void:
	closed.emit()
	hide()

# when the Master volume slider is changed
func _on_master_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	
# when the SFX volume slider is changed
func _on_sfx_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))

# when the BGM volume slider is changed
func _on_bgm_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), linear_to_db(value))
