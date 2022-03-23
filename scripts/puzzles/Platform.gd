extends Node2D

signal going_forward

export var destination : NodePath
export(float) var duration : float
export(bool) var horizontal : bool
onready var _origin : Vector2 = position
var _destination : Vector2

func _ready():
	_destination = get_node(destination).position
	if horizontal:
		_destination.y = _origin.y
	else:
		_destination.x = _origin.x

func go_forward():
	$Tween.stop(self)
	$Tween.interpolate_property(
		self,
		"position",
		position,
		_destination,
		_calc_duration(_destination),
		Tween.TRANS_LINEAR
	)
	$Tween.start()
	emit_signal("going_forward")

func go_backward():
	$Tween.stop(self)
	$Tween.interpolate_property(
		self,
		"position",
		position,
		_origin,
		_calc_duration(_origin),
		Tween.TRANS_LINEAR
	)
	$Tween.start()

func _calc_duration(target):
	var full = _origin.distance_to(_destination)
	var part = position.distance_to(target)
	return (part / full) * duration
