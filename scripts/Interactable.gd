extends Area2D

var partners = []
signal on_interact
signal interact_enter
signal interact_exit

func interact_entered(area):
	partners.append(area)
	emit_signal("interact_enter")

func interact_exited(area):
	partners.erase(area)
	emit_signal("interact_exit")

func _interact():
	emit_signal("on_interact")

func interact():
	for partner in partners:
		partner._interact()
