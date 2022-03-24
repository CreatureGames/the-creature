extends AudioStreamPlayer

export(Array, AudioStream) var tracks
var _cur_track = 0

func _ready():
	connect("finished", self, "next_track")

func next_track():
	_cur_track += 1
	if _cur_track >= tracks.size():
		_cur_track = 0
	stream = tracks[_cur_track]
