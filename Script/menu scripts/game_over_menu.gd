extends Control

func _on_retry_pressed():
	get_tree().change_scene_to_file("res://Scene/Level.tscn")


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scene/menues/main_menu.tscn")
