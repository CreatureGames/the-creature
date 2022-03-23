extends Node2D

signal going_forward

export var destination : NodePath
export(float) var duration : float
export(bool) var horizontal : bool
onready var _origin : Vector2 = position
var _destination : Vector2
var _signal_count : int = 0 # how many buttons are keeping platform in place?

func _ready():
	_destination = get_node(destination).position
	if horizontal:
		_destination.y = _origin.y
	else:
		_destination.x = _origin.x

# _body param makes function callable by area entered/exited events
func go_forward(_body=null):
	_signal_count += 1
	if _signal_count == 1:
		$Tween.stop_all()
		$Tween.remove_all()
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
		$Audio.play()

# _body param makes function callable by area entered/exited events
func go_backward(_body=null):
	_signal_count -= 1
	_signal_count = max(0, _signal_count)
	if _signal_count == 0:
		$Tween.stop_all()
		$Tween.remove_all()
		$Tween.interpolate_property(
			self,
			"position",
			position,
			_origin,
			_calc_duration(_origin),
			Tween.TRANS_LINEAR
		)
		$Tween.start()
		$Audio.play()

func _calc_duration(target):
	var full = _origin.distance_to(_destination)
	var part = position.distance_to(target)
	return (part / full) * duration

func stop_audio():
	$Audio.stop()
