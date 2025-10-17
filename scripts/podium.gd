extends Button


@onready var podium = $Sprite2D

func _on_mouse_entered() -> void:
	podium.apply_shader()


func _on_mouse_exited() -> void:
	podium.apply_shader()


func _on_pressed() -> void:
	SceneManager.change_scene("speech")
	
