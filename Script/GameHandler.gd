extends Node3D


var enemy_wave_array = Array([20,30,40])

@export var enemyScenes : Array[PackedScene]
@export var pathNodes : Array[Path3D]

var current_number_of_enemies : int;
var enemies_to_spawn : int;
var current_wave : int = 1;
var max_waves : int = 3;

var spawning : bool = true;
var spawning_delay : int = 3
var round_wait_delay : int = 10

func _get_number_of_enemies(wave_number : int) -> int:
	var enemy_number
	
	match wave_number:
		1:
			enemy_number = 20
		2:
			enemy_number = 30
		3:
			enemy_number = 40 
	
	return enemy_number

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(round_wait_delay-9.5).timeout
	_prepare_wave();

func _prepare_wave() -> void:
	enemies_to_spawn = _get_number_of_enemies(current_wave);
	spawning = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !spawning:
		spawning = true
		print("init timer")
		await get_tree().create_timer(spawning_delay).timeout
		print("spawning")
		_spawn_new_enemy();


func _spawn_new_enemy():
	if enemies_to_spawn >= 1:
		_add_enemy_to_lane();
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

func _add_enemy_to_lane():

	var spawn_ready_enemy = enemyScenes[_get_random_enemy()].instantiate();
	pathNodes[_get_random_path()].add_child(spawn_ready_enemy);

func _get_random_path() -> int:
	var path_number : int = 0;
	var rng = RandomNumberGenerator.new()
	var weight1 = 1030
	var weight2 = 250
	var weight3 = 1450
	var rand = rng.randf_range(0, weight1 + weight2 + weight3)

	if rand <= weight1:
		path_number = 0
	elif rand > weight1 && rand <= (weight1 + weight2):
		path_number = 1
	elif rand > (weight1 + weight2):
		path_number = 2

	return path_number

func _get_random_enemy() -> int:
	var enemy_number : int = 0;
	var rng = RandomNumberGenerator.new()
	var weight1 = 1030
	var weight2 = 250
	var weight3 = 1450
	var rand = rng.randf_range(0, weight1 + weight2 + weight3)

	if rand <= weight1:
		enemy_number = 1
	elif rand > weight1 && rand <= (weight1 + weight2):
		enemy_number = 2
	elif rand > (weight1 + weight2):
		enemy_number = 3

	return enemy_number