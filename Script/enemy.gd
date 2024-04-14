extends PathFollow3D

@onready var health = get_node("/root/Map1").current_enemy_health
@onready var enemy_speed : float = get_node("/root/Map1").current_enemy_speed
@export var projectileParticles : PackedScene
@export var enemyDeathParticles : PackedScene

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
		var particles = projectileParticles.instantiate()
		get_parent().add_child(particles)
		particles.global_position = body.global_position
		body.queue_free();
		if health <= 0:
			_enemy_death();

func _enemy_death():
	get_parent().get_parent().current_number_of_enemies -= 1
	GLOBALVARIABLES.amount_of_cash += randi_range(80, 110)
	var particles = enemyDeathParticles.instantiate()
	get_parent().add_child(particles)
	particles.global_position = global_position
	queue_free()
