extends Button

const USER_DATA_PATH: String = "user://save/"
const SAVE_FILE_NAME: String = "TheGameSave.tres"

var game_data = GameData.new()
var reset_in_progress: bool = false

## Saves to the actual file
func save_to_file() -> void:
    ResourceSaver.save(game_data, USER_DATA_PATH + SAVE_FILE_NAME)

func _ready() -> void:
    verify_save_directory(USER_DATA_PATH)

## verify that the save directory is available
func verify_save_directory(path : String) -> void:
    DirAccess.make_dir_absolute(path)

func clear_save_game() -> void:

    if ResourceLoader.exists(USER_DATA_PATH + SAVE_FILE_NAME):

        GLOBALVARIABLES.current_wave = 1
        GLOBALVARIABLES.amount_of_cash = 0
        GLOBALVARIABLES.health = 10
        GLOBALVARIABLES.tower_cost = 500
        GLOBALVARIABLES.scoreboard_array = [Array([0,0]),Array([0,0]),Array([0,0]),Array([0,0]),Array([0,0])]

        var wave_state_details = Array([GLOBALVARIABLES.current_wave, GLOBALVARIABLES.amount_of_cash])
        game_data.save_array(GLOBALVARIABLES.WAVE_STATE_DETAILS, wave_state_details)
        var scoreboard = Array([GLOBALVARIABLES.scoreboard_array])
        game_data.save_array(GLOBALVARIABLES.SCOREBOARD, scoreboard)

        ## SAVING BUILD SITES
        var build_sites_built: Array
        game_data.save_array(GLOBALVARIABLES.BUILD_SITES, Array([build_sites_built]))

        save_to_file()
