extends Node3D
var timer = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	$GPUParticles3D.emitting = true
	$AudioStreamPlayer.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer -= delta
	if timer <= 0:
		queue_free()
	pass
