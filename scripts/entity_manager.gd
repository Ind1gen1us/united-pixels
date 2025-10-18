class_name EntityManager extends Node

func human_entrance() -> void:
	get_tree().call_group("human_entity", "entering")

func toggle_selection() -> void:
	get_tree().call_group("entity", "toggle_selection")
