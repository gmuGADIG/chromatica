extends Node
class_name EnemySpawner

##NOTE: This is a temporary definition to test EntitySpawner functionality.
##TODO: Finish this class.

func spawn_enemies(enemies : Array) -> void:
	for enemy in enemies:
		print(enemy.identifier)
