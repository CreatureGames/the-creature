extends Node


# stores game data in user directory
# https://docs.godotengine.org/en/3.4/tutorials/io/data_paths.html
const GAME_DATA_PATH = "user://save_game.dat"

var active_menu		= null	# holds the active (visible) menu
var active_level	= null	# holds the game level currently being played
var level_num		= 1		# current highest level the player has completed


# DEBUGGING
#func _ready():
#	save_level_num(1)


######## SCENE MANAGEMENT ########

# hides main menu and loads proper level
func play_game() -> void:
	set_active_menu(null)
	level_num = load_level_num()
	load_level(level_num)

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
	save_level_num(level_num)
	get_tree().quit()

# pauses or unpauses the game
func toggle_pause() -> void:
	if not active_menu:
		get_tree().paused = true
		set_active_menu($CanvasLayer/PauseMenu)
	else:
		get_tree().paused = false
		set_active_menu(null)

# shows requested menu and hides previously visible menu
func set_active_menu(menu) -> void:
	if active_menu:
		active_menu.visible = false
	active_menu = menu
	if active_menu:
		active_menu.visible = true

# loads the specified level and returns true if successful
func load_level(level: int) -> bool:
	var result = false
	var path = "res://nodes/levels/Level%d.tscn" % level
	var f = File.new()
	if f.file_exists(path):
		active_level = load(path).instance()
		add_child(active_level)
		active_level.connect("completed", self, "level_completed")
		result = true
	return result

# removes level from tree and frees resources
func evict_level() -> void:
	# save level data if applicable
	remove_child(active_level)
	active_level.queue_free()
	active_level = null

# evicts current level, updates level counter, and loads next level
func level_completed() -> void:
	level_num += 1
	save_level_num(level_num)
	evict_level()
	
	# attempt to load level, but if no more remain...
	if not load_level(level_num):
		
		# reset level for next playthrough
		level_num = 1
		save_level_num(level_num)
		
		# TODO show credits or something?
		main_menu()


######## INPUT EVENTS ########

# handles app-related input (not movement/game input)
func _input(event) -> void:
	# pausing should only happen when playing a level
	if event.is_action_pressed("pause") and active_level:
		toggle_pause()


######## LEVEL DATA ########

# loads a level number from disk
func load_level_num() -> int:
	var level = 0 # default value of 0
	var file = File.new()
	var e = file.open(GAME_DATA_PATH, File.READ)
	if not e: # no error
		level = file.get_8()
		file.close()
	return level

# saves a number to disk, indicating the highest level the player has completed
# returns true on success
func save_level_num(level: int) -> bool:
	var result = false
	var file = File.new()
	var e = file.open(GAME_DATA_PATH, File.WRITE)
	if not e: # no error
		file.store_8(level)
		file.close()
		result = true
	return result
