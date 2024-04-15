extends Node3D



@export var enemyScenes : Array[PackedScene]
@export var pathNodes : Array[Path3D]

@onready var pause_menu = %pause_menu

var paused = false

##FOR TESTING
var total_cash : int = 0


var spawning_delay_default : float = 5.0

var enemies_to_spawn : int;
var current_enemy_speed : float;
var spawning_delay : float = spawning_delay_default;
var current_enemy_health : int;

var wave_countdown : bool
var wave_timer : float = round_wait_delay
var timer_counter : float = 0

var current_number_of_enemies : int;

var spawning : bool = true;
var round_wait_delay : float = 3-spawning_delay

func _set_wave_details(wave_number : int) -> void:

	var late_wave_incrementer : float = 0.0

	if wave_number < 5:
		late_wave_incrementer = wave_number*2
	else:
		late_wave_incrementer = wave_number
	
	if wave_number >= 5:
		late_wave_incrementer += floor(wave_number/5)

	enemies_to_spawn = int(wave_number * (4 + (late_wave_incrementer/2)))

	current_enemy_speed = 5 + (wave_number + late_wave_incrementer)/10
	
	if not spawning_delay <= 0.183:
		spawning_delay = spawning_delay_default - ((wave_number+late_wave_incrementer)/10.0)

	#limit the spawner speed
	if spawning_delay <= 0.183:
		spawning_delay = 0.183

	current_enemy_health = int(wave_number + late_wave_incrementer)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("cheat"):
		_update_cash(500)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_life_hud()
	_update_cash(0)
	_update_cost(GLOBALVARIABLES.tower_cost)
	wave_countdown = true
	%next_wave_label.text = str('Wave ',GLOBALVARIABLES.current_wave, ' in:') 
	round_wait_delay = 30
	wave_timer = round_wait_delay+spawning_delay
	%next_wave_timer.visible = true
	%enemies_left_hud.visible = false
	await get_tree().create_timer(round_wait_delay, false).timeout
	_prepare_wave();
	round_wait_delay = 20

func _prepare_wave() -> void:
	_set_wave_details(GLOBALVARIABLES.current_wave);
	%enemies_left_count.text = str(enemies_to_spawn + current_number_of_enemies)
	spawning = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Exit"):
		pauseMenu()
		%Player.release_mouse()
	
	if !spawning:
		spawning = true
		await get_tree().create_timer(spawning_delay, false).timeout
		_spawn_new_enemy();
	
	if wave_countdown:
		timer_counter += delta
		%next_wave_countdown.text = str(int(wave_timer-timer_counter))
		if timer_counter >= wave_timer:
			wave_countdown = false
			timer_counter = 0
			%next_wave_timer.visible = false
			%enemies_left_hud.visible = true


func _spawn_new_enemy():
	if enemies_to_spawn >= 1:
		_add_enemy_to_lane();
		current_number_of_enemies += 1;
		enemies_to_spawn -= 1
		spawning = false
	elif enemies_to_spawn <= 0 and current_number_of_enemies <= 0:
		wave_countdown = true
		%next_wave_timer.visible = true
		%enemies_left_hud.visible = false
		wave_timer = round_wait_delay+round(spawning_delay)
		GLOBALVARIABLES.current_wave += 1
		%next_wave_label.text = str('Wave ',GLOBALVARIABLES.current_wave, ' in:') 
		%save_handler.save_game()
		await get_tree().create_timer(round_wait_delay, false).timeout
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

	GLOBALVARIABLES.current_wave = 1
	GLOBALVARIABLES.amount_of_cash = 0
	GLOBALVARIABLES.health = 10
	%save_handler.save_game()

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

func pauseMenu():
	if paused:
		pause_menu.hide()
		get_tree().paused = false
	else:
		pause_menu.show()
		get_tree().paused = true
		
	paused = !paused

func _enemy_died():
	current_number_of_enemies -= 1
	%enemies_left_count.text = str(enemies_to_spawn + current_number_of_enemies)
	_update_cash(randi_range(100, 140))

func _handle_life_lost():
	GLOBALVARIABLES.health -= 1;
	
	if GLOBALVARIABLES.health <= 0:
		get_node("/root/Map1")._game_over()

	_update_life_hud()

func _update_life_hud():
	%lives_left_count.text = str(GLOBALVARIABLES.health)

func _update_cash(_cash_amount : int):
	if _cash_amount > 0:
		total_cash += _cash_amount
	GLOBALVARIABLES.amount_of_cash += _cash_amount
	%cash_amount.text = str(GLOBALVARIABLES.amount_of_cash)
	
func _update_cost(_cost_amount : int):
	GLOBALVARIABLES.tower_cost = _cost_amount
	%cost_amount.text = str(GLOBALVARIABLES.tower_cost, " $")

func _toggle_upgrade_screen(_cost_amount : int, toggle : bool, tower_level : int, tower : Node3D):
	%upgrade_hud.visible = toggle
	%upgrade_label.text = str("Press 'E' to upgrade to level ",tower_level+1) 
	%upgrade_cost.text = str(_cost_amount, " $")
	if tower_level < 10:
		%upgrade_stat_label.text = str("UPGRADE TOWER SPEED ++")
	else:
		
		%upgrade_stat_label.text = str("UPGRADE TOWER DAMAGE ++")


func _on_fallbox_body_entered(body:Node3D):
	_game_over()
