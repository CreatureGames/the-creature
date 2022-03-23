extends Node2D

export var zoom_speed : float

var target
onready var default_zoom : float = $Camera2D.zoom.x
onready var target_zoom : float = default_zoom

func set_target(_target):
	target = _target

func _process(delta):
	global_position = target.global_position
	var cur_zoom = $Camera2D.zoom.x
	$Camera2D.zoom = Vector2.ONE * (cur_zoom + (target_zoom - cur_zoom) * zoom_speed * delta)

func set_zoom(_body, zoom : float = default_zoom):
	target_zoom = zoom
