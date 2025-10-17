extends Node

# Scene paths - update these to match your project structure
const SCENES = {
	"assembly_room": "res://scenes/assemby_room.tscn",
	"speech": "res://scenes/speech.tscn",
	"write": "res://scenes/speech.tscn",

}

var current_scene: Node = null
var previous_scene_name: String = ""

func _ready():
	# Get the current scene that's already loaded
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

# Change to a new scene with optional transition
func change_scene(scene_name: String, use_transition: bool = true) -> void:
	if not SCENES.has(scene_name):
		push_error("Scene '%s' not found in SCENES dictionary!" % scene_name)
		return
	
	previous_scene_name = get_current_scene_name()
	var path = SCENES[scene_name]
	
	if use_transition:
		# Fade out and wait
		await fade_out()

	# Immediately change scene
	_deferred_change_scene(path)


func _deferred_change_scene(path: String) -> void:
	# Free the current scene immediately
	if current_scene:
		current_scene.queue_free()  # or free() if you are sure no references exist
	
	# Load and instance the new scene
	var new_scene = load(path).instantiate()
	current_scene = new_scene
	
	# Add it to the scene tree before fade-in
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	
	# Fade in and wait
	await fade_in()


# Reload the current scene
func reload_scene() -> void:
	var scene_name = get_current_scene_name()
	change_scene(scene_name)

# Go back to previous scene
func go_back() -> void:
	if previous_scene_name != "":
		change_scene(previous_scene_name)

# Get current scene name
func get_current_scene_name() -> String:
	for key in SCENES.keys():
		if SCENES[key] == current_scene.scene_file_path:
			return key
	return ""

# Quit the game
func quit_game() -> void:
	get_tree().quit()

# Pause/unpause the game
func toggle_pause() -> void:
	get_tree().paused = !get_tree().paused

func pause_game() -> void:
	get_tree().paused = true

func unpause_game() -> void:
	get_tree().paused = false

func fade_out() -> void: 
	var fade = ColorRect.new()
	fade.color = Color.BLACK
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade.set_anchors_preset(Control.PRESET_FULL_RECT)
	get_tree().root.add_child(fade)
	
	var tween = create_tween()
	tween.tween_property(fade, "modulate:a", 1.0, 0.3).from(0.0)
	await tween.finished
	fade.queue_free()


func fade_in() -> void:  
	var fade = ColorRect.new()
	fade.color = Color.BLACK
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade.set_anchors_preset(Control.PRESET_FULL_RECT)
	get_tree().root.add_child(fade)
	
	var tween = create_tween()
	tween.tween_property(fade, "modulate:a", 0.0, 0.3).from(1.0)
	await tween.finished
	fade.queue_free()
