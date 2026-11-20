extends Node2D
class_name PlayerAudio

var playDeath

@export var death_sound : AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playDeath = true


func _on_player_die() -> void:
	if(playDeath):
		playDeath = false
		death_sound.play()
