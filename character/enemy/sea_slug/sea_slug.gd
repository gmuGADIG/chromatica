extends Enemy
class_name SeaSlug

enum FacingDirection{
	LEFT = -1,
	RIGHT = 1
}
#static typing- use this as an example:
#@expot var speed : float
#for all variable which can be played with

var facingDirection : FacingDirection = FacingDirection.LEFT

@export var projectile : PackedScene 
@export var attack_cooldown : float = 1.5

var time_since_last_attack: float = 0.0

@export var shoot_point: Marker2D
#values taken from other compoenents in this gameobject:
#now inherited from enemy_behavior
#@export var health_component : HealthComponent
#@export var hitbox : EnemyHitbox
#@export var health_bar : ProgressBar
#@export var colorable_component : Colorable


## How far the wall & platform ray goes
@export var halt_distance : float = 500.0

@export var player_ray: RayCast2D 

@export var wall_ray : RayCast2D

@export var platform_ray : RayCast2D
#values taken from player/platform gameobject
var collider


#from enemy_behavior:

#vision is "goomba" like
func can_see_player() -> bool:
	#ray did not hit anything
	if not player_ray.is_colliding(): return false
	
	#ray hit !player
	collider = player_ray.get_collider()
	#ray hit player hitbox, return its parent
	if collider and (collider.is_in_group("player") or collider.get_parent().is_in_group("player")):
		print("Player detected!")
		return player_ray.is_colliding()
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

	return

#specific to this enemy:

func _update_facing_direction() -> void:
	wall_ray.target_position.x = facingDirection * halt_distance
	platform_ray.position.x = facingDirection * halt_distance
	player_ray.target_position.x = facingDirection * 1000
	sprite.flip_h = facingDirection == FacingDirection.LEFT
func floor_slime() -> void:
	#TODO: leaves trail of slime which will hurt the player
	#TODO: using default PNG as placeholder for slime trail
	return

func shoot_goop() -> void:
	if not projectile:
		push_warning("Projectile scene not assigned on sea slug")
		return
		
	var cur_projectile : GoopProjectile = projectile.instantiate()
	get_tree().current_scene.add_sibling(cur_projectile)
	
	
	# Position the projectile at the enemy's location
	cur_projectile.global_position = shoot_point.global_position
	#cur_projectile.global_rotation = global_rotation
	cur_projectile.projectile_velocity = Vector2(1000*facingDirection,0)
	#facingDirection *= -1
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
	if can_see_player() and time_since_last_attack >= attack_cooldown:
		print("attack")
		shoot_goop()
		# Reset the timer back to 0 after attacking
		time_since_last_attack = 0.0
		
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
