extends Node

const USER_DATA_PATH: String = "user://save/"
const SAVE_FILE_NAME: String = "TheGameSave.tres"

var game_data = GameData.new()
var reset_in_progress: bool = false

## Saves to the actual file
func save_to_file() -> void:
	ResourceSaver.save(game_data, USER_DATA_PATH + SAVE_FILE_NAME)

## Loads data from the actual file
func load_data() -> void:
	game_data = ResourceLoader.load(USER_DATA_PATH + SAVE_FILE_NAME).duplicate(true)

#returns a saved date
func load_date() -> String:
	return game_data.date

# Returns a saved ARRAY value which goes down three levels
# x for first level
# y for second level
# z for third level
# Example Array [["Car",["Bike", "Scooter"], "Train"], "Apple", ["Potato","Squash"]]
# load_array_data_n(0,1,0) would return "Bike"
# load_array_data_n(2,1) would return "Squash"
# load_array_data_n(2) would return ["Potato","Squash"]
# you can save and load any types of data here

## Currently supports 4 seperate arrays, all with 4 levels
## Add arrays to Resource.gd to expand

func load_array_data_n(n: int, x: int = -1, y:int = -1, z:int = -1):
	var return_value
	var saved_array = game_data.load_array(n)
	
	return_value = get_array_value(saved_array, x,y,z)

	return return_value

## Load an array value
# Will currently return array values. Uncomment code to get the first value in an array, when index is not specified
func get_array_value(saved_array, x,y,z):
	var return_value = ""
	if (x >= 0 && y >=0 && z >=0 && saved_array.size() > x
			&& typeof(saved_array[x]) == 28 && saved_array[x].size() > y 
			&& typeof(saved_array[x][y]) == 28 && saved_array[x][y].size() > z):
		return_value = saved_array[x][y][z]

	elif (x >= 0 && y >=0 && saved_array.size() > x 
			&& typeof(saved_array[x]) == 28 && saved_array[x].size() > y):
		#if (typeof(saved_array[x][y]) == 28):
		#	return_value = str(saved_array[x][y][0])
		#else:
		return_value = saved_array[x][y]

	elif (x >= 0 && saved_array.size() > x):
		#if (typeof(saved_array[x]) == 28):
		#	return_value = str(saved_array[x][0])
		#else:
		return_value = saved_array[x]

	return return_value

func load_current_state() -> void:
	##Loading the actual data
	load_data()
	GLOBALVARIABLES.current_wave = load_array_data_n(GLOBALVARIABLES.WAVE_STATE_DETAILS, GLOBALVARIABLES.WAVE_STATE_DETAILS_ENUM.CURRENT_WAVE)
	GLOBALVARIABLES.amount_of_cash = load_array_data_n(GLOBALVARIABLES.WAVE_STATE_DETAILS, GLOBALVARIABLES.WAVE_STATE_DETAILS_ENUM.MONEY_AMOUNT)
	GLOBALVARIABLES.scoreboard_array = load_array_data_n(GLOBALVARIABLES.SCOREBOARD, GLOBALVARIABLES.SCOREBOARD_ENUM.SCOREBOARD_SAVE)

	for built_sites in load_array_data_n(GLOBALVARIABLES.BUILD_SITES, GLOBALVARIABLES.BUILD_SITES_ENUM.BUILT_BUILD_SITES):
		var tower = get_node('/root/Map1/BuildSites/'+built_sites[0])
		tower.build(true)
		tower.tower_upgrade_level = built_sites[1]

func _ready() -> void:
	verify_save_directory(USER_DATA_PATH)
	_inital_load_or_save()

func _inital_load_or_save() -> void:
	if ResourceLoader.exists(USER_DATA_PATH + SAVE_FILE_NAME):
		load_current_state()
	else:
		save_game()

## verify that the save directory is available
func verify_save_directory(path : String) -> void:
	DirAccess.make_dir_absolute(path)

func save_game() -> void:
	var wave_state_details = Array([GLOBALVARIABLES.current_wave, GLOBALVARIABLES.amount_of_cash])
	game_data.save_array(GLOBALVARIABLES.WAVE_STATE_DETAILS, wave_state_details)
	var scoreboard = Array([GLOBALVARIABLES.scoreboard_array])
	game_data.save_array(GLOBALVARIABLES.SCOREBOARD, scoreboard)

	## SAVING BUILD SITES
	var build_sites_built: Array
	for build_site in get_node('/root/Map1/BuildSites').get_children():
		if build_site.built:
			build_sites_built.append(Array([build_site.name,build_site.tower_upgrade_level]))

	game_data.save_array(GLOBALVARIABLES.BUILD_SITES, Array([build_sites_built]))

	save_to_file()

## Deletes everything in the savefile
func clear_save() -> void:
	reset_in_progress = true
	save_game()
	save_to_file()
	reset_in_progress = false
