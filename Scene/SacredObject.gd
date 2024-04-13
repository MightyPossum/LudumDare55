extends Node3D

signal hit

@export var health = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func die():
	pass

func _on_area_body_entered(body):
	print('hit')
