extends Area2D


@export var force: float

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
	find_player()
	player.velocity += Vector2.from_angle(randf_range(0, 2 * PI)) * force

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	find_player()
			
	var self_pos := self.global_position
	var player_pos = player.global_position
	var dir_to_player := self_pos.direction_to(player_pos).normalized()
			
	match current_state:
		ColorStates.RED:			
			player.velocity += force * dir_to_player
		
		ColorStates.BLUE:
			player.velocity -= force * dir_to_player
		_:
			# How did we get here
			pass

func find_player() -> void:
	if not player:
		for body: Node2D in get_overlapping_bodies():
			if body.is_in_group("player"):
				player = body as Player
				break
