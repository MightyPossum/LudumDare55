extends PathFollow3D

@onready var health = get_node(GLOBALVARIABLES.gamehandler_path).current_enemy_health
@onready var enemy_speed : float = get_node(GLOBALVARIABLES.gamehandler_path).current_enemy_speed
@export var projectileParticles : PackedScene
@export var enemyDeathParticles : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%health_bar.visible = false
	%health_bar.max_value = health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	progress += enemy_speed * delta

func _update_progress_bar():
	%health_bar.visible = true
	%health_bar.value = health


func _attacked_sacred_object():
	_enemy_death();


func _on_area_3d_body_entered(body:Node3D):
	if body.is_in_group("projectile"):
		health -= body.damage;
		_update_progress_bar()
		var particles = projectileParticles.instantiate()
		get_parent().add_child(particles)
		particles.global_position = body.global_position
		$hurtPlayer.play()
		body.queue_free();
		if health <= 0:
			_enemy_death();

func _enemy_death():
	get_node(GLOBALVARIABLES.gamehandler_path)._enemy_died()
	var particles = enemyDeathParticles.instantiate()
	get_parent().add_child(particles)
	particles.global_position = global_position
	queue_free()
