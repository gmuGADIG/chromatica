extends Enemy
class_name Lunger

@export var attack_sight_range : AttackSightRange
@export var move_speed := 80.0

var player_in_range := false

func _ready() -> void:
	# These should go to parent, but leaving it here for now
	hitbox.health_component = health_component  
	
	# Applied for specific enemy types (attack sight)
	if attack_sight_range:
		attack_sight_range.player_entered.connect(_on_player_entered_range)
		attack_sight_range.player_exited.connect(_on_player_exited_range)
	
	# This stays for the child
	super._ready() #keep the parent's setup running

func _on_player_entered_range(_player: Player) -> void:
	#print ("pir t")
	player_in_range = true

func _on_player_exited_range(_player: Player) -> void:
	#print ("pir f")
	player_in_range = false

func _physics_process(delta: float) -> void:
	if player_in_range:
		velocity.x = 0
	else:
		velocity.x = -move_speed
	move_and_slide()
	
