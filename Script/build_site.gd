class_name buildSite extends Node3D

var player_in_area = false
var built = false
@export var cost_incrase = 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Use") and player_in_area == true:
		if not built:
			if GLOBALVARIABLES.amount_of_cash >= GLOBALVARIABLES.tower_cost:
				GLOBALVARIABLES.amount_of_cash -= GLOBALVARIABLES.tower_cost #Removes cash from global pool
				GLOBALVARIABLES.tower_cost = round(GLOBALVARIABLES.tower_cost * cost_incrase) #Cost increase every time a tower is built
				build()
			else:
				print("You don't have enough cash")

func build():
	$Tower.show()
	$TowerBuild.hide()
	built = true
	
func _on_area_3d_body_entered(body):
		player_in_area = true

func _on_area_3d_body_exited(body):
		player_in_area = false
