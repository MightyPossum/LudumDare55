extends Control

@onready var player = $"../../"

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scene/menues/main_menu.tscn")

func _on_resume_pressed():
	print('FIUCK')
	%Player.capture_mouse()
	get_node("/root/Map1").pauseMenu()
