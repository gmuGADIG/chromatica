class_name Bead
extends Node2D

enum BeadType {
	HIT_POINTS,
	RESTORE_AMOUNT,
	BUCKET_SLOT,
	ATTACK_SPEED,
	BUCKET_HEALING,
	PARRY_TIME,
}

@export var type : BeadType

signal collected_bead


func _on_interactable_interacted() -> void:
	Progression.add_bead(type)
	collected_bead.emit()
	queue_free()
