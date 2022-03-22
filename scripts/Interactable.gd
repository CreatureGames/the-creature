extends Area2D

var partners = []
signal on_interact
signal interact_enter
signal interact_exit

func interact_entered(area):
	emit_signal("interact_enter")
	partners.append(area)

func interact_exited(area):
	emit_signal("interact_exit")
	partners.erase(area)

func _interact():
	emit_signal("on_interact")

func interact():
	for partner in partners:
		partner._interact()
