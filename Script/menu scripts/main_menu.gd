extends Control

func _ready():
	get_tree().paused = false

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scene/new_level.tscn")


func _on_exit_pressed():
	get_tree().quit()
