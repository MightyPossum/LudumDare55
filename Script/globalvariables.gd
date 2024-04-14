extends Node

var current_wave : int = 1
var amount_of_cash : int = 0
var health : int = 10

var scoreboard_array : Array = [Array([0,0]),Array([0,0]),Array([0,0]),Array([0,0]),Array([0,0])]


enum {WAVE_STATE_DETAILS, SCOREBOARD}
enum WAVE_STATE_DETAILS_ENUM {CURRENT_WAVE, MONEY_AMOUNT}
enum SCOREBOARD_ENUM {SCOREBOARD_SAVE}
