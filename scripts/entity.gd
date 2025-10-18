class_name Entity extends AnimatedSprite2D # all "interactable" entities inherit from this class


@export var base_outline_color: Color # color of the outline shader
@export var pressed_outline_color:Color = Color(1,1,1,1)
@export var outline_thickness: float = 1.0 # thickness of the outline shader

@onready var shader_component:ShaderComponent = $ShaderComponent

var is_hovered: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shader_component.set_material()
	
func _on_button_mouse_exited() -> void:
	is_hovered = false
	shader_component.remove_shader()

func _on_button_mouse_entered() -> void:
	is_hovered = true
	shader_component.apply_shader()

func _on_button_button_up() -> void:
	# Return to base color when button is released (if still hovering)
	if is_hovered:
		shader_component.apply_shader()

func _on_button_button_down() -> void:
	print(name," selected")
	shader_component.apply_shader(pressed_outline_color)
