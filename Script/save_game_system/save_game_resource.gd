extends Resource
class_name GameData

@export var date: String = ""
@export var array_1: Array = []
@export var array_2: Array = []
@export var build_sites: Array = []
@export var array_4: Array = []

func save_date(value: String) -> void: ## Left as an example of ways to expand the save function, everything doesn't need to be an array
	date = value

# supply an lov_number from 1-4
# can be expanded by adding a variable above, to save_array, and to load_array
func save_array(lov_number: int, save_value: Array) -> void:
	match lov_number:
		0:
			array_1 = save_value
		1:
			array_2 = save_value
		2:
			build_sites = save_value
		3:
			array_4 = save_value

func load_array(lov_number: int) -> Array:
	match lov_number:
		0:
			return array_1
		1:
			return array_2
		2:
			return build_sites
		3:
			return array_4
		_:
			return array_1