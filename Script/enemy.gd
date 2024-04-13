extends PathFollow3D

var health = 5
@export var enemy_speed : int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	progress += enemy_speed * delta

func _on_area_3d_area_entered(area):
	if area.is_in_group("projectile"):
		health -= area.damage;

func _attacked_sacred_object():
	_enemy_death();


func _on_area_3d_body_entered(body:Node3D):
	if body.is_in_group("projectile"):
		health -= body.damage;
		if health <= 0:
			_enemy_death();

func _enemy_death():
	get_parent().current_number_of_enemies -= 1
	queue_free()