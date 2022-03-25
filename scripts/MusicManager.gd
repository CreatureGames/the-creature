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

func play_track(track: int):
	if stream != tracks[track]:
		var tween = get_node("Tween")
		tween.interpolate_property(self, "volume_db",
				-6.0, -60.0, 1.0,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		yield(tween, "tween_completed")
		stop()
		stream = tracks[track]
		tween.interpolate_property(self, "volume_db",
				-60.0, -6.0, 0.5,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		play()
		tween.start()

func play_track_after(_arg0, track: int):
	play_track(track)
