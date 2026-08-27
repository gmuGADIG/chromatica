@tool
extends Node
class_name DesaturationComponent

enum ColorSpace{
	HSL,
	HSV,
}

@export var shader : Shader
@export var target : CanvasItem:
	set(val):
		if not shader:
			push_error("Target refused. Desaturation shader not attached")
			return
		##Remove old shader
		if target != null and target != val:
			if target.material is ShaderMaterial:
				if target.material.shader == shader:
					target.material = null
		target = val
		var shader_mat : ShaderMaterial = ShaderMaterial.new()
		shader_mat.shader = shader
		target.material = shader_mat

@export_range(0,1.0,0.01) var red_scale : float = 1.0:
	set(val):
		red_scale = val
		if target:
			update_shader_parameters()
@export_range(0,1.0,0.01) var yellow_scale : float = 1.0:
	set(val):
		yellow_scale = val
		if target:
			update_shader_parameters()
@export_range(0,1.0,0.01) var blue_scale : float = 1.0:
	set(val):
		blue_scale = val
		if target:
			update_shader_parameters()
@export var color_space : ColorSpace = ColorSpace.HSV:
	set(val):
		color_space = val
		if target:
			update_shader_parameters()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update_shader_parameters() -> void:
	if not target.material is ShaderMaterial:
		push_error("Trying to operate on non-shader material")
		return
	var shader_mat : ShaderMaterial = target.material
	shader_mat.set_shader_parameter("red_scale",red_scale)
	shader_mat.set_shader_parameter("yellow_scale",yellow_scale)
	shader_mat.set_shader_parameter("blue_scale",blue_scale)
	shader_mat.set_shader_parameter("color_space",color_space)
