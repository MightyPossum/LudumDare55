class_name buildSite extends Node3D

var cost = GLOBALVARIABLES.tower_cost
var cash = GLOBALVARIABLES.amount_of_cash
var player_in_area = false
var built = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Use") and player_in_area == true:
		if not built:
			if cost >= cash:
				cash -= cost #Removes cash from global pool
				cost * 1.5 #Cost increase every time a tower is built
				build()

func build():
	$Tower.show()
	$TowerBuild.hide()
	built = true
	
func _on_area_3d_body_entered(body):
	player_in_area = true

func _on_area_3d_body_exited(body):
	player_in_area = false
