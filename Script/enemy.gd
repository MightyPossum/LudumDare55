extends PathFollow3D

var health = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	const move_speed = 50.5
	progress += move_speed * delta

func _on_area_3d_area_entered(area):
	if area.is_in_group("projectile"):
		health -= area.damage
