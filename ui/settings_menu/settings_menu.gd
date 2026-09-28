extends Control

var master_bus_index

func _ready() -> void:
	pass

func _on_button_pressed() -> void:
	hide() # hides the settings menu
	pass # Replace with function body.

# when the Master volume slider is changed
func _on_master_volume_changed(value: float) -> void:
	# changes the audio bus to the volume slider value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	pass # Replace with function body.
	
# when the SFX volume slider is changed
func _on_sfx_volume_changed(value: float) -> void:
	# changes the audio bus to the volume slider value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
	pass # Replace with function body.

# when the BGM volume slider is changed
func _on_bgm_volume_changed(value: float) -> void:
	# changes the audio bus to the volume slider value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), linear_to_db(value))
	pass # Replace with function body.
