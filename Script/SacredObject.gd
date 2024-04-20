extends Node3D

signal hit

func _on_area_area_entered(area):
	if area.is_in_group("enemy"):
		area.get_parent()._attacked_sacred_object();
		get_node("/root/Map1")._handle_life_lost()
