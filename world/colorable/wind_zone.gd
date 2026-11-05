extends Area2D

@export var force: float
@export var yellow_multiplier: float

enum ColorStates {
	RED, 
	BLUE, 
	YELLOW
}

var current_state : ColorStates = ColorStates.RED

@export var cooldown: float
@onready var yellow_timer := $YellowColorTimer as Timer

var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	yellow_timer.wait_time = cooldown
	yellow_timer.timeout.connect(yellow_gust)

func yellow_gust() -> void:
	if not find_player(): return
	player.velocity += global_transform.x * force * yellow_multiplier

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if not find_player(): return
	
	match current_state:
		ColorStates.RED:
			player.velocity += force * global_transform.x
		
		ColorStates.BLUE:
			player.velocity -= force * global_transform.x
		_:
			# How did we get here
			pass

func find_player() -> bool:
	for body: Node2D in get_overlapping_bodies():
		if body.is_in_group("player"):
			player = body as Player
			return true
	player = null
	return false
