extends Camera3D

@export var Camera = Camera3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$"..".size = DisplayServer.window_get_size()
	global_transform = Camera.global_transform
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$".".global_transform = Camera.global_transform
	pass
