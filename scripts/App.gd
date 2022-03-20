extends Node


# stores game data in user directory
# https://docs.godotengine.org/en/3.4/tutorials/io/data_paths.html
const GAME_DATA_PATH = "user://save_game.dat"

var active_menu		= null	# holds the active (visible) menu
var active_level	= null	# holds the game level currently being played
var level_num		= 0		# current highest level the player has completed


######## SCENE MANAGEMENT ########

# hides main menu and loads proper level
func play_game() -> void:
	set_active_menu(null)
	active_level = load("res://nodes/levels/Level%d.tscn" % level_num).instance()
	add_child(active_level)

# shows main menu
func main_menu() -> void:
	if active_level:
		evict_level()
	set_active_menu($CanvasLayer/MainMenu)

# hides main menu and shows help screen
func help_menu() -> void:
	set_active_menu($CanvasLayer/HelpMenu)

# saves game data and quits
func exit() -> void:
	save_level(level_num)
	get_tree().quit()

# pauses or unpauses the game
func toggle_pause() -> void:
	if not active_menu:
		set_active_menu($CanvasLayer/PauseMenu)
	else:
		set_active_menu(null)

# shows requested menu and hides previously visible menu
func set_active_menu(menu) -> void:
	if active_menu:
		active_menu.visible = false
	active_menu = menu
	if active_menu:
		active_menu.visible = true

# removes level from tree and frees resources
func evict_level() -> void:
	# save level data if applicable
	remove_child(active_level)
	active_level.queue_free()
	active_level = null


######## INPUT EVENTS ########

# handles app-related input (not movement/game input)
func _input(event) -> void:
	# pausing should only happen when playing a level
	if event.is_action_pressed("pause") and active_level:
		toggle_pause()


######## LEVEL DATA ########

# load the player's best level into local variable
func _ready():
	level_num = load_level()

# loads a level number from disk
func load_level() -> int:
	var level = 0 # default value of 0
	var file = File.new()
	var e = file.open(GAME_DATA_PATH, File.READ)
	if not e: # no error
		level = file.get_8()
		file.close()
	return level

# saves a number to disk, indicating the highest level the player has completed
# returns true on success
func save_level(level: int) -> bool:
	var result = false
	var file = File.new()
	var e = file.open(GAME_DATA_PATH, File.WRITE)
	if not e: # no error
		file.store_8(level)
		file.close()
		result = true
	return result
