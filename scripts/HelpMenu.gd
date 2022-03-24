extends CenterContainer

signal main_menu

export var default_control : NodePath

func menu_pressed():
	emit_signal("main_menu")
