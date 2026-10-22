class_name Bead
extends Node

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


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is PlayerHitbox:
		ProgressionSystem.add_bead(type)
		collected_bead.emit()
		queue_free()
