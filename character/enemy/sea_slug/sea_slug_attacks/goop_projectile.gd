extends Area2D
class_name GoopProjectile

@export var projectile_speed : float = 50.00

#custom functions
func hit_something(body: Node2D) -> void:
	print("Goop hit: ", body.name)
	
	# If it hit the player, you could deal damage here later!
	if body.is_in_group("player"):
		print("player was hit")
		# TODO: Deal damage to player's health component
		pass
	destroy_self()
	
func destroy_self() -> void:
	queue_free()
	pass

#built in functions
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position -= transform.x * projectile_speed * delta


func _on_body_entered(body: Node2D) -> void:
	hit_something(body)
