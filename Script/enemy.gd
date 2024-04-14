extends PathFollow3D

@onready var health = get_node("/root/Map1").current_enemy_health
@onready var enemy_speed : float = get_node("/root/Map1").current_enemy_speed

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
		body.queue_free();
		if health <= 0:
			_enemy_death();

func _enemy_death():
	get_parent().get_parent().current_number_of_enemies -= 1
	GLOBALVARIABLES.amount_of_cash += randi_range(80, 110)
	print("You have coins: ", GLOBALVARIABLES.amount_of_cash)
	queue_free()
