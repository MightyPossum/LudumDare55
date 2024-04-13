extends Node3D

signal hit

@export var health = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func game_over():
	pass

func _on_area_area_entered(area):
	health -= 1
	if area.is_in_group("enemy"):
		area.get_parent()._attacked_sacred_object();
