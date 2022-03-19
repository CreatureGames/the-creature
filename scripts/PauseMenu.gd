extends CenterContainer

signal play_game
signal main_menu


func play_pressed():
	emit_signal("play_game")

func menu_pressed():
	emit_signal("main_menu")
