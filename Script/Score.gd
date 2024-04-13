extends Label

var score = 0
var high_score = 0


func _ready():
	_get_high_score()

func _on_wave_survived():
	score += 1
	text = "Score: %s" % score

func _on_game_loss():
	#save to file
	pass

func _get_high_score():
	high_score = 1
