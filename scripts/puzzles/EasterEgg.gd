extends Area2D

export var animator : NodePath
var _played : bool = false

func reveal(_body):
	if not _played:
		get_node(animator).play("reveal")
		_played = true
