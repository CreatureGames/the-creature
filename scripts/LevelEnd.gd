extends Area2D

export var level : NodePath

onready var _level : Node = get_node(level)

func end_level(_body):
	_level.emit_signal("completed")
