extends CharacterBody2D
class_name Enemy

@export var health_component : HealthComponent
@export var hitbox : EnemyHitbox
@export var health_bar : ProgressBar
@export var desaturation_component : DesaturationComponent
@export var colorable_component : Colorable


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
