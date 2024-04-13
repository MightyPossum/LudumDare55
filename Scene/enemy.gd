extends PathFollow3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	const move_speed = 4.5
	progress += move_speed * delta

	if progress_ratio >= 1:
		queue_free();
