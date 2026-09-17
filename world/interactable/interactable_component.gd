extends Area2D
class_name Interactable

signal interacted

func interact() -> void:
	interacted.emit()
	print(name + " interacted with")
	pass
