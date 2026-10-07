extends Node

#@export var invuln_component : InvulnComponent
@export var parry_duration : float 
@export var parry_cooldown : float

@onready var cooldown_timer: Timer = %ParryCooldown
@onready var duration_timer: Timer = %ParryDuration

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cooldown_timer.wait_time = parry_cooldown
	duration_timer.wait_time = parry_duration

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
		if event.is_action_pressed("paint_guard") and cooldown_timer.is_stopped():
			paint_guard()

func paint_guard() -> void:
	invuln_component.activate(parry_duration)
	duration_timer.start()
	await duration_timer.timeout
	cooldown_timer.start()
	
	
	
