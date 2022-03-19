extends Node


# hides main menu and loads proper level
func play_game():
	$MainMenu.visible = false
	add_child(load("res://nodes/levels/Level0.tscn").instance())

# hides main menu and shows help screen
func help_menu():
	$MainMenu.visible = false

# saves game data and quits
func exit():
	get_tree().quit()
