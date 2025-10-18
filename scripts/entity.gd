class_name Entity extends AnimatedSprite2D # all "interactable" entities inherit from this class


@export var base_outline_color: Color # color of the outline shader
@export var pressed_outline_color:Color = Color(1,1,1,1)
@export var outline_thickness: float = 1.0 # thickness of the outline shader

@onready var shader_component:ShaderComponent = $ShaderComponent

var is_hovered: bool = false
var can_be_selected: bool = false # toggling the shader outline application

func toggle_selection()->void:
	can_be_selected = not can_be_selected
	
# wrapping the base apply_shader() and remov_shader() to account for the toggling
func apply_shader(color= null) -> void:
	if can_be_selected:
		if color:
			shader_component.apply_shader(color)
			return
		shader_component.apply_shader()

func remove_shader() -> void:
	if can_be_selected:
		shader_component.remove_shader()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shader_component.set_material()
	
func _on_button_mouse_exited() -> void:
	is_hovered = false
	remove_shader()

func _on_button_mouse_entered() -> void:
	is_hovered = true
	apply_shader()

func _on_button_button_up() -> void:
	# Return to base color when button is released (if still hovering)
	if is_hovered:
		apply_shader()

func _on_button_button_down() -> void:
	print(name," selected")
	apply_shader(pressed_outline_color)
