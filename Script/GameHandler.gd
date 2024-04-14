extends Node3D

var enemy_wave_array = Array([20,30,40])
var late_wave_incrementer : float = 0.0

@export var enemyScenes : Array[PackedScene]
@export var pathNodes : Array[Path3D]


var spawning_delay_default : float = 5.0

var enemies_to_spawn : int;
var current_enemy_speed : float;
var spawning_delay : float = spawning_delay_default;
var current_enemy_health : int;

var current_number_of_enemies : int;

var spawning : bool = true;
var round_wait_delay : int = 2

func _set_wave_details(wave_number : int) -> void:	
	
	if wave_number <= 5:
		late_wave_incrementer += 2.0
	elif wave_number%5 == 0:
		late_wave_incrementer += 2.0

	if wave_number == 1:
		late_wave_incrementer += 6
	elif wave_number == 10:
		late_wave_incrementer -= 6

	enemies_to_spawn = int(wave_number * (4 + (late_wave_incrementer/2)))

	current_enemy_speed = 5 + (wave_number + late_wave_incrementer)/10
	
	if not spawning_delay <= 0.183:
		spawning_delay = spawning_delay_default - ((wave_number+late_wave_incrementer)/10.0)

	#limit the spawner speed
	if spawning_delay <= 0.183:
		spawning_delay = 0.183

	current_enemy_health = int(5 + late_wave_incrementer)

	%save_handler.save_game()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_scoreboard()
	await get_tree().create_timer(round_wait_delay).timeout
	_prepare_wave();

func _prepare_wave() -> void:
	_set_wave_details(GLOBALVARIABLES.current_wave);
	spawning = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if !spawning:
		spawning = true
		await get_tree().create_timer(spawning_delay).timeout
		_spawn_new_enemy();

func _spawn_new_enemy():
	if enemies_to_spawn >= 1:
		_add_enemy_to_lane();
		current_number_of_enemies += 1;
		enemies_to_spawn -= 1
		spawning = false
	elif enemies_to_spawn <= 0 and current_number_of_enemies <= 0:
		await get_tree().create_timer(round_wait_delay).timeout
		GLOBALVARIABLES.current_wave += 1
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
	var weight1 = 500
	var weight2 = 350
	var weight3 = 1500
	var weigth4 = 1250
	var rand = rng.randf_range(0, weight1 + weight2 + weight3 + weigth4)

	if rand <= weight1:
		path_number = 0
	elif rand > weight1 && rand <= (weight1 + weight2):
		path_number = 1
	elif rand > weight1 && rand > weight2 && rand <= (weight1 + weight2 + weight3):
		path_number = 2
	elif rand > (weight1 + weight2 + weight3):
		path_number = 3

	return path_number

func _get_random_enemy() -> int:
	var enemy_number : int = 0;
	var rng = RandomNumberGenerator.new()
	var weight1 = 1030
	var weight2 = 870
	var weight3 = 250
	var rand = rng.randf_range(0, weight1 + weight2 + weight3)

	if rand <= weight1:
		enemy_number = 0
	elif rand > weight1 && rand <= (weight1 + weight2):
		enemy_number = 1
	elif rand > (weight1 + weight2):
		enemy_number = 2

	return enemy_number

func _game_over():

	_update_scoreboard()

	GLOBALVARIABLES.current_wave = 0
	GLOBALVARIABLES.amount_of_cash = 0

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://Scene/menues/game_over_menu.tscn")

func _update_scoreboard():
	var scoreboard_array = GLOBALVARIABLES.scoreboard_array
	
	var lowest_wave : int = scoreboard_array[0][0]
	var array_location_low : int = 0

	var current_wave : int = GLOBALVARIABLES.current_wave
	
	for i in range(1,scoreboard_array.size()):
		if scoreboard_array[i][0] < lowest_wave:
			lowest_wave = scoreboard_array[i][0]
			array_location_low = i
	
	if lowest_wave < current_wave:
		GLOBALVARIABLES.scoreboard_array[array_location_low] = Array([current_wave, 0])
