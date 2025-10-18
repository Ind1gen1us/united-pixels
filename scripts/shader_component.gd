class_name ShaderComponent extends Node

@onready var root = get_parent()  # must be a direct child of the root node
var shader: Shader = preload("res://shaders/outline.gdshader")
var default_material: ShaderMaterial

## Create a new ShaderMaterial instance to avoid sharing between instances
func set_material() -> void:
	default_material = ShaderMaterial.new()
	default_material.shader = shader
	root.material = default_material

## Applies or updates the outline shader with specified color and thickness.
## [param color]: The color of the outline (defaults to base_outline_color)
## [param thickness]: The thickness of the outline in pixels (defaults to outline_thickness)
func apply_shader(color: Color = root.base_outline_color, thickness: float = root.outline_thickness) -> void:
	default_material.set_shader_parameter("line_color", color)
	default_material.set_shader_parameter("line_thickness", thickness)

## Removes the outline shader effect by setting thickness to 0.
func remove_shader() -> void:
	default_material.set_shader_parameter("line_thickness", 0.0)
