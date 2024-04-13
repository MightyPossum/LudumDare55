extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _get_number_of_enemies(wave_number : int) -> int:
	var enemy_number
	
	match wave_number:
		1:
			enemy_number = 20
		2:
			enemy_number = 30
		3:
			enemy_number = 40 
	
	return enemy_number
