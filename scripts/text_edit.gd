extends TextEdit

@export var default_position: Vector2 = Vector2(621, 451)
@onready var hand : AnimatedSprite2D = $"../../Hand"
var hand_position: Vector2
var is_writing = false
var last_input_time = 0.0
@export var writing_timeout = 0.5  # Stop animation after 0.5s of no input
var current_line_number: int = 0  # Track which line we're on

func _ready() -> void:
	hand_position = default_position
	current_line_number = 0

func _process(delta: float) -> void:
	if is_writing:
		hand_position = get_caret_screen_pos()
		hand.move_to(hand_position)
		
		# Check if user stopped typing
		if Time.get_ticks_msec() / 1000.0 - last_input_time > writing_timeout:
			is_writing = false
			hand.stop_writing()
	else:
		hand.stop_writing()

func get_caret_screen_pos() -> Vector2:
	var caret_column = get_caret_column()
	
	# Get font and metrics
	var font = self.get_theme_font("font", "TextEdit")
	if font == null:
		font = ThemeDB.fallback_font
	
	var font_size = self.get_theme_font_size("font_size", "TextEdit")
	if font_size <= 0:
		font_size = 16  # Fallback size
	
	# Get the actual line height used by TextEdit
	var line_height = get_line_height()
	
	# Get text before caret for width calculation
	var caret_line = get_caret_line()
	var line_text = self.get_line(caret_line)
	var text_before_caret = line_text.substr(0, caret_column)
	
	# Calculate horizontal position
	var caret_x = font.get_string_size(text_before_caret, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
	
	# Get LOCAL position of TextEdit
	var text_edit_local_pos = self.position
	
	# Get padding
	var style_box = get_theme_stylebox("normal", "TextEdit")
	var left_padding = style_box.content_margin_left if style_box else 5.0
	var top_padding = style_box.content_margin_top if style_box else 5.0
	
	# Calculate X position (follows caret horizontally)
	var x_position = text_edit_local_pos.x + left_padding + caret_x
	
	# Calculate Y position based on current_line_number (NOT caret_line)
	# This keeps the hand on the same visual line until Enter is pressed
	var y_position = default_position.y + (current_line_number * line_height)
	
	var final_pos = Vector2(x_position, y_position)
	
	# Check if hand is going below the TextEdit visible area
	var text_edit_bottom = text_edit_local_pos.y + self.size.y
	
	if y_position > text_edit_bottom - line_height:
		# Hand reached bottom, scroll down
		var scroll_amount = line_height
		set_v_scroll(get_v_scroll_bar().value + scroll_amount)
		# Keep hand at same visual position after scroll
		y_position -= scroll_amount
		final_pos.y = y_position
	
	return final_pos

func _on_text_changed() -> void:
	is_writing = true
	last_input_time = Time.get_ticks_msec() / 1000.0
	# Force update hand position immediately
	hand_position = get_caret_screen_pos()

func _on_focus_entered() -> void:
	hand.visible = true
	hand.set_to_default_position(default_position)
	hand.animate()
	# Reset to first line
	current_line_number = 0
	set_v_scroll(0)
	print("Gained focus")

func _on_focus_exited() -> void:
	is_writing = false
	hand.stop_writing()
	print("Lost focus")

func _input(event: InputEvent) -> void:
	if event is InputEventKey and has_focus() and event.pressed:
		is_writing = true
		last_input_time = Time.get_ticks_msec() / 1000.0
		
		# Check if Enter key was pressed
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			# Move to next line
			current_line_number += 1
			hand.move_down_line()
			print("Enter pressed - moving to line: ", current_line_number)
