extends CenterContainer

signal play_game
signal help_menu
signal exit


func play_pressed():
	emit_signal("play_game")

func help_pressed():
	emit_signal("help_menu")

func exit_pressed():
	emit_signal("exit")
