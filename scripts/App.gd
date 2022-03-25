extends Node


# stores game data in user directory
# https://docs.godotengine.org/en/3.4/tutorials/io/data_paths.html
const GAME_DATA_PATH = "user://save_game.dat"

export var tile_map : NodePath

var active_menu		= null	# holds the active (visible) menu
var active_level	= null	# holds the game level currently being played
var level_num		= 1		# current highest level the player has completed
var loader			= null	# used for async level loading
var time_max		= 100	# max time to block loading thread
onready var _menu_tiles = get_node(tile_map)

var found_easter_egg := false


######## SCENE MANAGEMENT ########

# hides main menu and loads proper level
func play_game(level: int) -> void:
	set_active_menu(null)
	level_num = level
	load_level(level_num)
	get_tree().paused = false

# shows main menu
func main_menu() -> void:
	if active_level:
		call_deferred("evict_level")
	set_active_menu($CanvasLayer/MainMenu)

# hides main menu and shows help screen
func help_menu() -> void:
	set_active_menu($CanvasLayer/HelpMenu)

# shows credits screen
func credits_menu() -> void:
	set_active_menu($CanvasLayer/CreditsMenu)

# shows level selection screen
func level_menu() -> void:
	set_active_menu($CanvasLayer/LevelMenu)
	$CanvasLayer/LevelMenu.init_buttons()

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
		if active_menu.default_control:
			active_menu.get_node(active_menu.default_control).grab_focus()
		
		if active_menu != $CanvasLayer/PauseMenu:
			if not has_node(_menu_tiles.name):
				call_deferred("add_child", _menu_tiles)
	elif has_node(_menu_tiles.name):
		call_deferred("remove_child", _menu_tiles)

# loads the specified level and returns true if successful
func load_level(level: int) -> bool:
	var result = false
	var path = "res://nodes/levels/Level%d.tscn" % level
	var f = File.new()
	if f.file_exists(path):
		loader = ResourceLoader.load_interactive(path)
		if loader == null: # Check for errors.
			print("Error in load_level")
		set_process(true)
		set_active_menu($CanvasLayer/LoadingScreen)
		result = true
	return result

# called when level is finally loaded
func level_loaded(level) -> void:
	set_active_menu(null)
	active_level = level
	call_deferred("add_child", active_level)
	active_level.connect("completed", self, "level_completed")

# async loading stuff
# https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html
func _process(time) -> void:
	if loader == null:
		# no need to process anymore
		set_process(false)
		return
	
	var t = OS.get_ticks_msec()
	# Use "time_max" to control for how long we block this thread.
	while OS.get_ticks_msec() < t + time_max:
		# Poll your loader.
		var err = loader.poll()
		
		if err == ERR_FILE_EOF: # Finished loading.
			var resource = loader.get_resource()
			loader = null
			level_loaded(resource.instance())
			break
		elif err == OK:
			pass # update loading animation or something
		else: # Error during loading.
			print("Error in _process")
			loader = null
			break

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
	call_deferred("evict_level")
	
	# attempt to load level, but if no more remain...
	if not load_level(level_num):
		
		# reset level for next playthrough
		level_num = 1
		save_level_num(level_num)
		
		# show credits
		credits_menu()


######## INPUT EVENTS ########

# handles app-related input (not movement/game input)
func _input(event) -> void:
	# pausing should only happen when playing a level
	if event.is_action_pressed("pause") and active_level:
		toggle_pause()
	elif event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen


######## LEVEL DATA ########

# loads a level number from disk
func load_level_num() -> int:
	var level = 1 # default value of 1
	var file = File.new()
	var e = file.open(GAME_DATA_PATH, File.READ)
	if not e: # no error
		level = file.get_8()
		found_easter_egg = bool(file.get_8())
		file.close()
	return level

# saves a number to disk, indicating the highest level the player has completed
# returns true on success
func save_level_num(level: int) -> bool:
	var result = true
	
	# only save level if it's bigger than the currently saved one
	if level > load_level_num():
		var file = File.new()
		var e = file.open(GAME_DATA_PATH, File.WRITE)
		if not e: # no error
			file.store_8(level)
			file.store_8(int(found_easter_egg))
			file.close()
		else: # error saving
			result = false
	
	return result
