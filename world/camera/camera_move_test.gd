extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var lookLeft

func _ready() -> void:
	lookLeft = false


func _physics_process(_delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
	#	velocity += get_gravity() * delta (we are not worrying about gravity right now)

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		lookLeft = velocity.x < 0 #the player is responsible for keeping track of direction 
		$Camera/Camera2D.center(self.lookLeft) #center camera when moving (also pass in direction to store for later)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$Camera/Camera2D.shift() #get camera to shift

	move_and_slide()
