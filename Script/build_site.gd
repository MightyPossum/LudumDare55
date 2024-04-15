extends Node3D

var player_in_area = false
var show_build_panel = false
@export var built = false
@export var cost_incrase = 1.5

var tower_upgrade_level = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Use") and player_in_area == true:
		if not built:
			if GLOBALVARIABLES.amount_of_cash >= GLOBALVARIABLES.tower_cost:
				get_node(GLOBALVARIABLES.gamehandler_path)._update_cash(-GLOBALVARIABLES.tower_cost)
				build()

func build():
	get_node(GLOBALVARIABLES.gamehandler_path)._update_cost(round(GLOBALVARIABLES.tower_cost * cost_incrase))
	$Tower.show()
	$TowerBuild.hide()
	%Tower.built = true
	built = true
	GLOBALVARIABLES.build = false
	
func _on_area_3d_body_entered(body):
	player_in_area = true
	if not built:
		GLOBALVARIABLES.build = true
	else:
		print('UPGRADE ME')

func _on_area_3d_body_exited(body):
	player_in_area = false
	if not built:
		GLOBALVARIABLES.build = false
