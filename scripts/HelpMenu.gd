extends CenterContainer


signal main_menu


func menu_pressed():
	emit_signal("main_menu")
