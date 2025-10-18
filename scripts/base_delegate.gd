class_name Delegate extends Entity

@export var pos_to_add: Vector2 = Vector2(30, 0)
@export var default_position: Vector2
@export var entrance_duration: float = 2.5 # Duration of the entrance animation in seconds

func _ready() -> void:
	super._ready() # check base class
	print("default pos: ", default_position)


## Plays the entrance animation when delegates enter the assembly room.
## Animates position and fade-in using tweens.
func entering() -> void:
	# Set initial state
	position = default_position
	modulate = Color(1.0, 1.0, 1.0, 0.0)  # Start fully transparent
	
	# Create tween
	var tween = create_tween()

	# Animate position
	tween.tween_property(self, "position", default_position + pos_to_add, entrance_duration)
	tween.set_parallel()  # Run both animations simultaneously
	# Animate fade-in
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), entrance_duration)
