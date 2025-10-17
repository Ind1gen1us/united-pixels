class_name Delegate extends AnimatedSprite2D # all human entities inherit from this class

@onready var animation_player = $AnimationPlayer
@export var pos_to_add: Vector2 = Vector2(30,0)
@export var outline_color: Color
@export var outline_thickness: float = 1.0
var current_position: Vector2
var shader :Shader= preload("res://shaders/outline.gdshader")
var default_material: ShaderMaterial
var shader_applied:= false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default_material = material
	current_position = global_position
	entering()
	apply_shader()

func entering() -> void:
	"""
	Playing an animation when the delegates get into the assmbly room
	"""
	var base_animation :Animation= animation_player.get_animation("entrance")
	base_animation .track_set_key_value(0,0, current_position)
	current_position += pos_to_add
	base_animation.track_set_key_value(0,1, current_position)
	animation_player.play("entrance")
	
func apply_shader() -> void:
	if not shader_applied:
		default_material.shader = shader
		#accessing and setting the parameters of our shader material
		default_material.set_shader_parameter("line_color", outline_color)
		default_material.set_shader_parameter("line_thickness", outline_thickness)
		
		
	else:
		default_material.shader = null
	shader_applied = not shader_applied
