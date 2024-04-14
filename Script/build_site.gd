class_name buildSite extends Node3D

var player_in_area = false
@export var built = false
@export var cost_incrase = 1.5

signal built1(built)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Use") and player_in_area == true:
		if not built:
			if GLOBALVARIABLES.amount_of_cash >= GLOBALVARIABLES.tower_cost:
				get_node(GLOBALVARIABLES.gamehandler_path)._update_cash(-GLOBALVARIABLES.tower_cost)
				build()

func build():
	GLOBALVARIABLES.tower_cost = round(GLOBALVARIABLES.tower_cost * cost_incrase) #Cost increase every time a tower is built
	$Tower.show()
	$TowerBuild.hide()
	%Tower.built = true
	built = true
	
func _on_area_3d_body_entered(body):
		player_in_area = true

func _on_area_3d_body_exited(body):
		player_in_area = false
