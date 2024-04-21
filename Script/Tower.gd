extends Node3D

@export var projectileModel : PackedScene

var enemies_in_range:Array[Node3D]
var current_enemy:Node3D = null
var built = false
var tower_damage : float

var fire_delay : float
var reload : bool = false
var check_for_enemies : bool = true

func _ready():
	pass

func _process(_delta):
	if built && current_enemy != null and built == true:
			_attack(current_enemy)

func _physics_process(_delta):
	if check_for_enemies && built:
		check_for_enemies = false
		if enemies_in_range.size() > 0:
			await get_tree().create_timer(0.25, false).timeout
			for enemy in enemies_in_range:
				get_parent().get_node('RayCast3D').look_at(enemy.global_position, Vector3.UP)
				get_parent().get_node('RayCast3D').force_raycast_update()
				if get_parent().get_node('RayCast3D').is_colliding():
					var collider = get_parent().get_node('RayCast3D').get_collider()
					if collider.get_parent().is_in_group('enemy'):
							current_enemy = enemy
							break;

		check_for_enemies = true
	
func _attack(rtarget):
	if !reload:
		var projectile = projectileModel.instantiate()
		get_parent().add_child(projectile)
		projectile.damage = tower_damage
		
		var target_direction = rtarget.global_transform.origin
		
		projectile.global_position = $Model/Crystal.global_position
		projectile.look_at(target_direction)
		reload = true
		await get_tree().create_timer(fire_delay, false).timeout
		reload = false
		
		
func _on_area_3d_area_entered(area):
	enemies_in_range.append(area)

func _on_area_3d_area_exited(area):
	if area == current_enemy:
		current_enemy = null
	enemies_in_range.erase(area)

func _calculate_stats(upgrade_level : int):
	if upgrade_level == 1:
		fire_delay = 1
		tower_damage = 0.75
		%RangeShape.shape.radius += (upgrade_level)
	elif upgrade_level <= 19:
		fire_delay = 1 - ((upgrade_level-1) * 0.05)
		tower_damage = 0.75 * (upgrade_level/2)
		%RangeShape.shape.radius += (upgrade_level)
	else:
		fire_delay = 1 - (19 * 0.05)
		tower_damage = 0.75 * (upgrade_level/2)
		%RangeShape.shape.radius += (19)
		


func _get_range():
	return %RangeShape.shape.radius