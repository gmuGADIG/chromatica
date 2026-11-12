extends AudioStreamPlayer2D

var playDeath


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playDeath = true


func _on_player_die() -> void:
	if(playDeath):
		playDeath = false
		play()
		print("hi")
