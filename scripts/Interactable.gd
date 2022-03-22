extends Area2D

var partners = []
signal on_interact

func interact_entered(area):
	partners.append(area)

func interact_exited(area):
	partners.erase(area)

func _interact():
	emit_signal("on_interact")

func interact():
	for partner in partners:
		partner._interact()
