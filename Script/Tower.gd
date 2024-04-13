extends Node3D

var enemy_array = []
var built = false

func _ready():
	if built:
		self.get_node("StaticBody3D/Turret").get_shape().radius = 0.5

func _physics_process(delta):
	turn()
	
func turn():
	var enemy_postion = global_position
	get_node("StaticBody3D/Turret").look_at(enemy_postion)

func _on_area_3d_area_entered(area):
	enemy_array.append(area.get_parent())
	print(enemy_array)

func _on_area_3d_area_exited(area):
	enemy_array.erase(area.get_parent())
