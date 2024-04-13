extends Path3D

var current_number_of_enemies : int;
var enemies_to_spawn : int;
var current_wave : int = 1;
var max_waves : int = 3;

var spawning : bool = true;
var spawning_delay : int = 3
var round_wait_delay : int = 10

@export var enemy1scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(round_wait_delay-9.5).timeout
	_prepare_wave();

func _prepare_wave() -> void:
	enemies_to_spawn = get_node("/root/Map1")._get_number_of_enemies(current_wave);
	spawning = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !spawning:
		spawning = true
		print("init timer")
		await get_tree().create_timer(spawning_delay).timeout
		print("spawning")
		_spawn_new_enemy(enemy1scene);


func _spawn_new_enemy(enemy_scene : PackedScene):
	if enemies_to_spawn >= 1:
		var spawn_ready_enemy = enemy_scene.instantiate();
		add_child(spawn_ready_enemy);
		current_number_of_enemies += 1;
		enemies_to_spawn -= 1
		spawning = false
	elif enemies_to_spawn <= 0 and current_number_of_enemies <= 0 and current_wave < max_waves:
		await get_tree().create_timer(round_wait_delay).timeout
		current_wave += 1
		_prepare_wave();
		spawning = false
	else:
		spawning = false
