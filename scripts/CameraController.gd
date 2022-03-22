extends Node2D

var target

func set_target(_target):
	target = _target

func _process(delta):
	global_position = target.global_position
