extends Node
class_name PlayerAnimations

@export var sprite : AnimatedSprite2D

@export var player_movement : PlayerMovement

func _ready() -> void:
	player_movement.on_jump.connect(_on_jump)
	player_movement.on_falling.connect(_on_fall)
	player_movement.on_land.connect(_on_land)
	sprite.animation_finished.connect(_on_animation_finished)
	
func _on_jump() -> void:
	#print("jump")
	sprite.play("jump")

func _on_fall() -> void:
	#print("Fall")
	sprite.play("fall")

func _on_land() -> void:
	print("land")
	sprite.play("land")

func _on_animation_finished() -> void:
	match sprite.animation:
		"land":
			sprite.play("idle")
