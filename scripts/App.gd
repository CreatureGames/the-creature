extends Node


var active_menu	= null # holds the active (visible) menu
var level		= null # holds the game level currently being played


# hides main menu and loads proper level
func play_game():
	set_active_menu(null)
	level = load("res://nodes/levels/Level0.tscn").instance()
	add_child(level)

# shows main menu
func main_menu():
	if level:
		evict_level()
	set_active_menu($CanvasLayer/MainMenu)

# hides main menu and shows help screen
func help_menu():
	set_active_menu($CanvasLayer/HelpMenu)

# saves game data and quits
func exit():
	get_tree().quit()

# pauses or unpauses the game
func toggle_pause():
	if not active_menu:
		set_active_menu($CanvasLayer/PauseMenu)
	else:
		set_active_menu(null)

# shows requested menu and hides previously visible menu
func set_active_menu(menu):
	if active_menu:
		active_menu.visible = false
	active_menu = menu
	if active_menu:
		active_menu.visible = true

# removes level from tree and frees resources
func evict_level():
	# save level data if applicable
	remove_child(level)
	level.queue_free()
	level = null

# handles app-related input (not movement/game input)
func _input(event):
	if event.is_action_pressed("pause") and level:
		toggle_pause()
