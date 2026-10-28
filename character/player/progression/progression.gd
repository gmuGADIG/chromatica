extends Node

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
var unlocked_items : Dictionary[Unlockable,bool] = {
	Unlockable.RED_COLOR : false,
	Unlockable.YELLOW_COLOR : false,
	Unlockable.BLUE_COLOR : false,
}

var beads_collected : Dictionary[Bead.BeadType,int] = {
	Bead.BeadType.HIT_POINTS : 0,
	Bead.BeadType.RESTORE_AMOUNT : 0,
	Bead.BeadType.BUCKET_SLOT : 0,
	Bead.BeadType.ATTACK_SPEED : 0,
	Bead.BeadType.BUCKET_HEALING : 0,
	Bead.BeadType.PARRY_TIME : 0,
}

signal collected_bead(bead : Bead.BeadType, new_amount : int)

# function to unlock an unlockable by setting its boolean to true
func unlock(unlock : Unlockable) -> void:
	unlocked_items.set(unlock, true)

# function to check if the player has someting unlocked
func is_unlocked(unlock : Unlockable) -> bool:
	return unlocked_items.get(unlock) or DEBUG_UNLOCK_ALL
	
func add_bead(bead : Bead.BeadType):
	beads_collected.set(bead,beads_collected.get(bead))
	collected_bead.emit(bead, beads_collected.get(bead))
