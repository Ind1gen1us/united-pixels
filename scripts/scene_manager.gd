extends Node

# Scene paths - update these to match your project structure
const SCENES = {
	"assembly_room": "res://scenes/assemby_room.tscn",
	"speech": "res://scenes/speech.tscn",
	"write": "res://scenes/speech.tscn",
}

var current_scene: Node = null
var previous_scene_name: String = ""
var scene_data: Dictionary = {}  # Stores data to pass to the next scene

func _ready():
	# Get the current scene that's already loaded
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

# Change to a new scene with optional transition and data
# data can be:
# - A Dictionary with multiple keys for flexible data passing
# - Any other type (will be wrapped in a dict with "data" key)
func change_scene(scene_name: String, use_transition: bool = true, data: Variant = null) -> void:
	if not SCENES.has(scene_name):
		push_error("Scene '%s' not found in SCENES dictionary!" % scene_name)
		return
	
	previous_scene_name = get_current_scene_name()
	var path = SCENES[scene_name]
	
	# Store the data to pass to the next scene
	if data != null:
		if data is Dictionary:
			# If it's already a dictionary, use it directly (allows multiple keys)
			scene_data = data.duplicate()
		else:
			# Wrap non-dictionary data
			scene_data = {"data": data}
		
		# Always add metadata
		scene_data["_from_scene"] = previous_scene_name
		scene_data["_timestamp"] = Time.get_ticks_msec()
	else:
		scene_data = {}
	
	if use_transition:
		await fade_out()
	
	_deferred_change_scene(path)

func _deferred_change_scene(path: String) -> void:
	# Free the current scene immediately
	if current_scene:
		current_scene.queue_free()
	
	# Load and instance the new scene
	var new_scene = load(path).instantiate()
	current_scene = new_scene
	
	# Add it to the scene tree before initializing
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	
	# Pass data to the new scene if it has the appropriate method
	if scene_data.size() > 0:
		_pass_data_to_scene(new_scene)
	
	# Fade in and wait
	await fade_in()

# Internal method to pass data to the scene
func _pass_data_to_scene(scene: Node) -> void:
	# Method 1: Call a method if it exists (passes entire dictionary)
	if scene.has_method("receive_scene_data"):
		scene.receive_scene_data(scene_data)
	
	# Method 2: Set individual properties that match dictionary keys
	else:
		for key in scene_data.keys():
			# Skip metadata keys
			if key.begins_with("_"):
				continue
			
			if key in scene:
				scene.set(key, scene_data[key])
		
		# Also try to notify children
		_notify_children_recursively(scene, scene_data)

# Recursively notify children about scene data
func _notify_children_recursively(node: Node, data: Dictionary) -> void:
	if node.has_method("receive_scene_data"):
		node.receive_scene_data(data)
	
	for child in node.get_children():
		_notify_children_recursively(child, data)

# Get specific data from scene_data
func get_data(key: String, default: Variant = null) -> Variant:
	return scene_data.get(key, default)

# Get all scene data
func get_scene_data() -> Dictionary:
	return scene_data

# Check if specific data exists
func has_data(key: String) -> bool:
	return scene_data.has(key)

# Clear scene data
func clear_scene_data() -> void:
	scene_data = {}

# Reload the current scene
func reload_scene(preserve_data: bool = false) -> void:
	var scene_name = get_current_scene_name()
	var data = scene_data.duplicate() if preserve_data else null
	change_scene(scene_name, true, data)

# Go back to previous scene
func go_back(data: Variant = null) -> void:
	if previous_scene_name != "":
		change_scene(previous_scene_name, true, data)

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
