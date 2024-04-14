extends Node3D

var enemies_in_range:Array[Node3D]
var current_enemy:Node3D = null

@export var projectileModel : PackedScene

var last_fire_time:int
@export var fire_rate:int = 1000

func _ready():
	pass

func _process(delta):
	if current_enemy != null:
		_attack(current_enemy, delta)
	
func _attack(rtarget, delta):
	if Time.get_ticks_msec() > (last_fire_time+fire_rate):
		var projectile = projectileModel.instantiate()
		get_parent().add_child(projectile)
		
		var target_direction = rtarget.global_transform.origin
		
		projectile.global_position = $Turret/Muzzle.global_position
		projectile.look_at(target_direction)
		
		last_fire_time = Time.get_ticks_msec()
		
func _on_area_3d_area_entered(area):
	if current_enemy == null:
		current_enemy = area
	
	enemies_in_range.append(area)

func _on_area_3d_area_exited(area):
	enemies_in_range.erase(area)
