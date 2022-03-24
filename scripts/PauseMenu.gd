extends CenterContainer

signal play_game
signal main_menu

export var default_control : NodePath

func play_pressed():
	emit_signal("play_game")

func menu_pressed():
	emit_signal("main_menu")
