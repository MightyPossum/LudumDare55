extends Node3D

var enemies_in_range:Array[Node3D]
var current_enemy:Node3D = null
var built = false

@export var projectileModel : PackedScene

var fire_delay : int = 1
var reload : bool = false

func _ready():
	pass

func _process(delta):
	if current_enemy != null and built == true:
		_attack(current_enemy, delta)
	else:
		current_enemy = enemies_in_range.front()
	
func _attack(rtarget, delta):
	if !reload:
		var projectile = projectileModel.instantiate()
		get_parent().add_child(projectile)
		
		var target_direction = rtarget.global_transform.origin
		
		projectile.global_position = $Model/Crystal.global_position
		projectile.look_at(target_direction)
		reload = true
		await get_tree().create_timer(fire_delay).timeout
		reload = false
		
		
func _on_area_3d_area_entered(area):
	enemies_in_range.append(area)

func _on_area_3d_area_exited(area):
	if area == current_enemy:
		current_enemy = null
	enemies_in_range.erase(area)


