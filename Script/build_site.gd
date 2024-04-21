extends Node3D

var player_in_area = false
var show_build_panel = false
var built = false

var tower_upgrade_level = 1

var cost_increase = 1.5
var upgrade_cost_increase = 1.75
var upgrade_cost : int
var total_sunken_cost : int

var base_upgrade_cost : int = 650


# Called when the node enters the scene tree for the first time.
func _ready():
	_calculate_stats()

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Use") and player_in_area == true:
		if not built:
			if GLOBALVARIABLES.amount_of_cash >= GLOBALVARIABLES.tower_cost:
				get_node(GLOBALVARIABLES.gamehandler_path)._update_cash(-GLOBALVARIABLES.tower_cost)
				build(false)
		else:
			if GLOBALVARIABLES.amount_of_cash >= upgrade_cost:
				_upgrade_tower()

func build(built_from_load : bool):
	get_node(GLOBALVARIABLES.gamehandler_path)._update_cost(round(GLOBALVARIABLES.tower_cost * cost_increase))
	$Tower.show()
	$TowerBuild.hide()
	%Tower.built = true
	built = true
	GLOBALVARIABLES.build = false
	if !built_from_load:
		get_node(GLOBALVARIABLES.gamehandler_path)._toggle_upgrade_screen(upgrade_cost, true, tower_upgrade_level)

func _upgrade_tower():
	tower_upgrade_level += 1
	get_node(GLOBALVARIABLES.gamehandler_path)._update_cash(-upgrade_cost)
	_calculate_stats()
	get_node(GLOBALVARIABLES.gamehandler_path)._toggle_upgrade_screen(upgrade_cost, true, tower_upgrade_level)
	
func _on_area_3d_body_entered(_body):
	player_in_area = true
	if not built:
		GLOBALVARIABLES.build = true
	else:
		get_node(GLOBALVARIABLES.gamehandler_path)._toggle_upgrade_screen(upgrade_cost, true, tower_upgrade_level)

func _on_area_3d_body_exited(_body):
	player_in_area = false
	if not built:
		GLOBALVARIABLES.build = false
	else:
		get_node(GLOBALVARIABLES.gamehandler_path)._toggle_upgrade_screen(upgrade_cost, false, tower_upgrade_level)

func _calculate_stats():
	var tower = %Tower
	tower._calculate_stats(tower_upgrade_level)

	%RayCast3D.target_position.z = -tower._get_range()

	if tower_upgrade_level == 1:
		upgrade_cost = base_upgrade_cost
	elif tower_upgrade_level == 2:
			upgrade_cost = int(base_upgrade_cost*upgrade_cost_increase)
	else:
		upgrade_cost = int(base_upgrade_cost + base_upgrade_cost*(tower_upgrade_level-2)*upgrade_cost_increase)
		
