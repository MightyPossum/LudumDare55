extends Node3D

@export var enemy1scene : PackedScene
var timer : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _spawn_new_enemy(enemy_scene : PackedScene):
	var spawn_ready_enemy = enemy_scene.instantiate();
	%Path1.add_child(spawn_ready_enemy);