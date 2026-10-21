extends EnemyBehavior

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
#values taken from other compoenents in this gameobject:
@export var health_component : HealthComponent
@export var hitbox : EnemyHitbox
@export var health_bar : ProgressBar
@export var colorable_component : Colorable
@onready var vision_ray: RayCast2D = $can_see_Player_ray
#values taken from player/platform gameobject
var collider


#from enemy_behavior:

#vision is "goomba" like
func can_see_player() -> bool:
	collider = vision_ray.get_collider()
	#found player
	if(collider.get_parent() =="Player"):
		return vision_ray.is_colliding()
	#found something else, probably wall/platform
	else:
		return false

#the nature of this enemy does not require
#setting a target, so this is in case enemy
#behaviour changes later in development
func set_target(pos: Vector2) -> void:
	#the players collider is the target
	pos = Vector2(0,0)
	return

#movement is "red koopa" like on platforms
func move(delta: float) -> void:
	return
func attack() -> void:
	return
#specific to this enemy:

#Godot functions:

#prepare all default values here
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body = get_parent() as Enemy
	if body == null:
		push_error("%s must be a direct child of an Enemy." % name)
		set_physics_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#best for non physics (particles/UI/animations)
func _process(delta: float) -> void:
	pass

#same as _process, but best used for physics 
#ex: (collisions/movement tied to physics)
#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
