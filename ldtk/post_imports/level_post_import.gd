@tool

func post_import(level: LDTKLevel) -> LDTKLevel:
	level.add_to_group("LDTKLevel",true)
	return level
