extends Node2D

##Whenever the camera should be offset left (true) or right (false)
var offsetLeft
##The speed to perform the camera offset
@export var offsetSpeed = 3
##The maximum x value to offset by
@export var maxOffset = 200
##How smooth the offset should be (higher value means more gentle stop)
@export var offsetSmoothness = 0.014

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	offsetLeft = false
	self.limit_left = -2000
	self.limit_right = 2000

func center(offset: bool) -> void:
	print("The player is currently moving")
	self.offsetLeft = offset #set offsetLeft to direction player last moved
	self.offset.x = 0 #reset offset position

func shift() -> void:
	print("The player is stopped")
	if(self.position.x > self.limit_left and self.position.x < self.limit_right): # do not offset if we reach the bounds 
		if(offsetLeft): #if we should offset left and we aren't going too far, offset more left
			if(maxOffset > abs(self.offset.x)):
				self.offset.x -= offsetSpeed + (self.offset.x * offsetSmoothness)
		else: #if we should offset right and we aren't going too far, offset more right
			if(maxOffset > self.offset.x):
				self.offset.x += offsetSpeed - (self.offset.x * offsetSmoothness)
