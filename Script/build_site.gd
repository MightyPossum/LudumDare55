extends Node3D

var player_in_area = false
var show_build_panel = false
var built = false

var tower_upgrade_level = 1

var cost_increase = 1.5
var upgrade_cost_increase = 1.75
var upgrade_cost : int
var total_sunken_cost : int


# Called when the node enters the scene tree for the first time.
func _ready():
	upgrade_cost = 650
	_calculate_stats()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Use") and player_in_area == true:
		if not built:
			if GLOBALVARIABLES.amount_of_cash >= GLOBALVARIABLES.tower_cost:
				get_node(GLOBALVARIABLES.gamehandler_path)._update_cash(-GLOBALVARIABLES.tower_cost)
				build()
		else:
			if GLOBALVARIABLES.amount_of_cash >= upgrade_cost:
				_upgrade_tower()

func build():
	get_node(GLOBALVARIABLES.gamehandler_path)._update_cost(round(GLOBALVARIABLES.tower_cost * cost_increase))
	$Tower.show()
	$TowerBuild.hide()
	%Tower.built = true
	built = true
	GLOBALVARIABLES.build = false
	get_node(GLOBALVARIABLES.gamehandler_path)._toggle_upgrade_screen(upgrade_cost, true, tower_upgrade_level, %Tower)

func _upgrade_tower():
	tower_upgrade_level += 1
	get_node(GLOBALVARIABLES.gamehandler_path)._update_cash(-upgrade_cost)
	total_sunken_cost += upgrade_cost
	upgrade_cost = total_sunken_cost * upgrade_cost_increase
	_calculate_stats()
	get_node(GLOBALVARIABLES.gamehandler_path)._toggle_upgrade_screen(upgrade_cost, true, tower_upgrade_level, %Tower)
	
func _on_area_3d_body_entered(body):
	player_in_area = true
	if not built:
		GLOBALVARIABLES.build = true
	else:
		get_node(GLOBALVARIABLES.gamehandler_path)._toggle_upgrade_screen(upgrade_cost, true, tower_upgrade_level, %Tower)

func _on_area_3d_body_exited(body):
	player_in_area = false
	if not built:
		GLOBALVARIABLES.build = false
	else:
		get_node(GLOBALVARIABLES.gamehandler_path)._toggle_upgrade_screen(upgrade_cost, false, tower_upgrade_level, %Tower)

func _calculate_stats():
	var tower = %Tower
	if tower_upgrade_level == 1:
		tower.fire_delay = 1
		tower.tower_damage = 0.5
	elif tower_upgrade_level <= 10:
		tower.fire_delay = 1 - (tower_upgrade_level-1 * 0.1)
		tower.tower_damage = 0.5
	else:
		tower.fire_delay = 1 - (9 * 0.1)
		tower.tower_damage = 0.5 + tower_upgrade_level-10
