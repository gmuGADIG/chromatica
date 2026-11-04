extends Node

var timer: Timer = Timer.new()
var sfx: AudioStreamPlayer = AudioStreamPlayer.new()

func reset_timer() -> void:
	if timer.is_inside_tree():
		timer.start(45.)

func _ready() -> void:
	sfx.stream = preload("splat.ogg")

	await get_tree().process_frame

	add_sibling(timer)
	add_sibling(sfx)

	timer.one_shot = false
	timer.timeout.connect(_on_timer_timeout)
	reset_timer()

func _input(_event: InputEvent):
	reset_timer()

func _on_timer_timeout() -> void:
	sfx.play()
