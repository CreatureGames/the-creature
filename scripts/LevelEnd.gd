extends Area2D

export var level : NodePath

onready var _level : Node = get_node(level)

func end_level(body):
	if body is PlayerRobot:
		if body.has_creature:
			_level.emit_signal("completed")
		else:
			body.emote("lowbattery", true)
