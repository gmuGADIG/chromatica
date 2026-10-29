extends Area2D


@export var force: float

enum ColorStates {
	RED, 
	BLUE, 
	YELLOW
}

var current_state : ColorStates = ColorStates.RED

@export var cooldown: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	# do timer shit here for yellow

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	for body: Node2D in get_overlapping_bodies():
		if body.is_in_group("player"):
			
			# Type safety
			var player := body as Player
			
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
