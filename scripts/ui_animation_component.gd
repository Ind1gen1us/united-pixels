class_name UIAnimationComponent extends Node

signal unfocus(element_array:Array)

# exporting parameters of the tween
@export var time:float = 1.0
@export var x_size: Vector2
@export var transition: Tween.TransitionType

var focused = false # button is not focused by default
var buttons: Array
var default_size
var origin: Button # parent node of the component

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	origin = get_parent()
	buttons = get_parent().get_parent().get_children() # getting each button node
	origin.pressed.connect(focus)
	unfocus.connect(_on_unfocus)
	default_size = origin.size


func animate_tween(final_value:Vector2) -> void:
	var position_tween = get_tree().create_tween()
	position_tween.tween_property(origin, "size", final_value, time).set_trans(transition)
	

func focus() -> void:
	print("pressed")
	unfocus.emit(buttons) # unfocusing all the other buttons first
	if not focused:
		var new_size = default_size + x_size
		animate_tween(new_size) 
		focused = not focused
	print(focused)
	
func _on_unfocus(button) -> void:
	for element in button:
		element = element.get_child(0) # getting the animation componendt
		# cuz that's where the script is attached
		if element.focused: # unfocusing the button
			element.animate_tween(default_size)
			element.focused = not element.focused
		
