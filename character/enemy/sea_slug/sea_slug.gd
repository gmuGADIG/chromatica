extends Enemy
#static typing- use this as an example:
#@expot var speed : float
#for all variable which can be played with
@export var projectile : PackedScene 
@export var attack_cooldown : float = 1.5

var time_since_last_attack: float = 0.0

@onready var shoot_point: Marker2D = $shoot_point
#values taken from other compoenents in this gameobject:
#now inherited from enemy_behavior
#@export var health_component : HealthComponent
#@export var hitbox : EnemyHitbox
#@export var health_bar : ProgressBar
#@export var colorable_component : Colorable

@onready var vision_ray: RayCast2D = $can_see_Player_ray
#values taken from player/platform gameobject
var collider


#from enemy_behavior:

#vision is "goomba" like
func can_see_player() -> bool:
	#ray did not hit anything
	if not vision_ray.is_colliding(): return false
	
	#ray hit !player
	collider = vision_ray.get_collider()
	#ray hit player hitbox, return its parent
	if collider and (collider.is_in_group("player") or collider.get_parent().is_in_group("player")):
		print("Player detected!")
		return vision_ray.is_colliding()
	#return if player not found
	else:
		return false

#the nature of this enemy does not require
#setting a target
func set_target(pos: Vector2) -> void:
	return

#movement is "red koopa" like on platforms
#consider disabling gravity, or changing value
#this will be important for walls
func move(delta: float) -> void:
	#TODO: move along platform/wall untill we reach the end, then, turn around
	return

#projectiles do not use gravity, they go streight until they hit something
func attack() -> void:
	# Check if the cooldown timer has expired
	if time_since_last_attack >= attack_cooldown:
		print("attack")
		shoot_goop()
		
		# Reset the timer back to 0 after attacking
		time_since_last_attack = 0.0
	return

#specific to this enemy:
func floor_slime() -> void:
	#TODO: leaves trail of slime which will hurt the player
	#TODO: using default PNG as placeholder for slime trail
	return

func shoot_goop() -> void:
	if not projectile:
		push_warning("Projectile scene not assigned on sea slug")
		return
		
	var cur_projectile = projectile.instantiate()
	get_tree().current_scene.add_child(cur_projectile)
	
	
	# Position the projectile at the enemy's location
	cur_projectile.global_position = shoot_point.global_position
	#cur_projectile.global_position = global_position
	cur_projectile.global_rotation = global_rotation
	return
	
#Godot functions:
#prepare all default values here
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#best for non physics (particles/UI/animations)
func _process(delta: float) -> void:
	pass

#same as _process, but best used for physics 
func _physics_process(delta: float) -> void:
	# 1. Always let time accumulate smoothly every frame
	time_since_last_attack += delta
	
	# 2. If we see the player, try to attack (attack() handles checking the cooldown timer)
	if can_see_player():
		attack()
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
