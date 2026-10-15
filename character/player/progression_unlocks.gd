class_name ProgressionUnlocks

static var DEBUG_UNLOCK_ALL : bool = false

# enum that contains all possible unlocks
# will need to be updated will the unlocks in the game
enum Unlockable {
	RED_COLOR,
	YELLOW_COLOR,
	BLUE_COLOR,
}

# dictionary that includes all the unlocks and a boolean for if the player has the unlock or not
# will also need to be updated with all the unlocks in the game
static var unlocked_items : Dictionary = {
	Unlockable.RED_COLOR : false,
	Unlockable.YELLOW_COLOR : false,
	Unlockable.BLUE_COLOR : false,
}

# function to unlock an unlockable by setting its boolean to true
static func unlock(unlock : Unlockable) -> void:
	unlocked_items.set(unlock, true)

# function to check if the player has someting unlocked
static func is_unlocked(unlock : Unlockable) -> bool:
	return unlocked_items.get(unlock)
