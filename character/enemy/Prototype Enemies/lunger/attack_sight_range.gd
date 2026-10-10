extends Area2D
class_name AttackSightRange

signal player_entered(player: Player)
signal player_exited(player: Player)

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_entered.emit(body)
		#print("Hit")

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_exited.emit(body)
		#print("Leaved")
