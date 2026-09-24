extends Node2D

##Whenever the camera should be offset left (true) or right (false)
var offsetLeft
##The position of the player that this camera is attached to
var playerPos
##The speed to perform the camera offset
@export var offsetSpeed = 3
##The maximum x value to offset by
@export var maxOffset = 200
##How smooth the offset should be (higher value means more gentle stop)
@export var offsetSmoothness = 0.014
##constant number to prevent the player from peeking past the bounds of a level (also keeps the camera center when an edge is reached)
@export var peekConstraint = 600

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	offsetLeft = false #assume player is looking right to start (since most levels go left to right)
	playerPos = Vector2(0,0) #assume player position is origin
	self.limit_left = -2000 #sample level bounds for the left (will not scroll past this value)
	self.limit_right = 2000 #sample level bounds for the right (will not scroll past this value)

func center(offset: bool) -> void:
	#get player position
	playerPos = get_parent().get_parent().position
	self.offsetLeft = offset #set offsetLeft to direction player last moved
	if(abs(self.offset.x) < 3): #if we are within 3 units from 0, just snap to 0 for smoothness
		self.offset.x = 0
	elif(self.offset.x > 0): #if we are to the right, shift to the left
		self.offset.x -= offsetSpeed + (self.offset.x * offsetSmoothness)
	else: #if we are to the left, shift to the right
		self.offset.x += offsetSpeed - (self.offset.x * offsetSmoothness)

func shift() -> void:
	#only shift left if we are facing left, and we are not looking too far to the left
	if(offsetLeft and playerPos.x > (self.limit_left + peekConstraint - self.offset.x)):
		if(maxOffset > abs(self.offset.x)): #also don't shift if we shifted the max distance
			self.offset.x -= offsetSpeed + (self.offset.x * offsetSmoothness) #shift left, slowing down as we reach the bound
	#only shift right if we are facing right, and we are not looking too far to the right
	elif(not offsetLeft and playerPos.x < (self.limit_right - peekConstraint - self.offset.x)): #if we should offset right and we aren't going too far, offset more right
		if(maxOffset > self.offset.x): #also don't shift if we shifted the max distance
			self.offset.x += offsetSpeed - (self.offset.x * offsetSmoothness) #shift right, slowing down as we reach the bound
