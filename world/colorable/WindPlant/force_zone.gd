extends Area2D
class_name ForceZone

@export var force: float
@export var yellow_multiplier: float

var current_state : Paint.Hue = Paint.Hue.RED

@export var cooldown: float
@onready var yellow_timer := $YellowColorTimer as Timer

var player: Player

func _ready() -> void:
	yellow_timer.wait_time = cooldown
	yellow_timer.timeout.connect(yellow_gust)

func yellow_gust() -> void:
	if not find_player(): return
	player.velocity += global_transform.x * force * yellow_multiplier

func _physics_process(_delta: float) -> void:
	if not find_player(): return
	
	match current_state:
		Paint.Hue.RED:
			player.velocity += force * global_transform.x
		
		Paint.Hue.BLUE:
			player.velocity -= force * global_transform.x
		_:
			# How did we get here
			pass


func change_state(new_state: Paint.Hue) -> void:
	current_state = new_state


func find_player() -> bool:
	for body: Node2D in get_overlapping_bodies():
		if body.is_in_group("player"):
			player = body as Player
			return true
	player = null
	return false
