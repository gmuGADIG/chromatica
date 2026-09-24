extends Area2D

@export var attack_duration: float = 0.5
#change to a longer time when find out what durration should be
var base_damage: int = 2
var dash_damage: int = 2
var upper_damage: int = 2
var down_damage: int = 2
#all attacks do the same damage since currently
#will be changed when I find out how much damage they should do
var damage

func _input(event: InputEvent):
	if event.is_action_pressed("basic_attack"):
		# Prevent attacking when already mid-attack
		if monitoring==true: return
		#maybe wepon move
		monitoring = true
		print("weapon visable now")
		damage = base_damage
		await get_tree().create_timer(attack_duration).timeout
		monitoring = false
		#maybe wepon move back to wherever it came from
		print("weapon hidden now")
	if event.is_action_pressed("dash_attack"):
		# Prevent attacking when already mid-attack
		if monitoring==true: return
		#maybe wepon move
		monitoring = true
		print("weapon visable now")
		damage = dash_damage
		await get_tree().create_timer(attack_duration).timeout
		monitoring = false
		#maybe wepon move back to wherever it came from
		print("weapon hidden now")
	if event.is_action_pressed("basic_attack"):#&& [whatever upper movment key is]
		# Prevent attacking when already mid-attack
		if monitoring==true: return
		#maybe wepon move
		monitoring = true
		print("weapon visable now")
		damage = upper_damage
		await get_tree().create_timer(attack_duration).timeout
		monitoring = false
		#maybe wepon move back to wherever it came from
		print("weapon hidden now")
	if event.is_action_pressed("dash_attack"):#&& [whatever downward movment key is]
		# Prevent attacking when already mid-attack
		if monitoring==true: return
		#maybe wepon move
		monitoring = true
		print("weapon visable now")
		damage = down_damage
		await get_tree().create_timer(attack_duration).timeout
		monitoring = false
		#maybe wepon move back to wherever it came from
		print("weapon hidden now")
	#passes damage value to healthbox somehow
