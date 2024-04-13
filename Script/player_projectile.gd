extends CharacterBody3D
@export var speed : int
@export var decayTime : int
var timer
var damage = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = decayTime
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer -= delta
	if timer <= 0:
		queue_free()
	velocity = transform.basis.z * speed
	move_and_collide(-velocity*delta)
	pass
