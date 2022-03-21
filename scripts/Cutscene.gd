extends AnimationPlayer


signal playing_cutscene
signal cutscene_ended

# can this cutscene be played more than once?
export(bool) var repeatable : bool

var has_played : bool = false


# expected to be called by Area2D, which passes the "body" parameter
func play_animation(_body, anim):
	if not is_playing() and (repeatable or not has_played):
		emit_signal("playing_cutscene")
		play(anim)
		has_played = true

# called when the animation ends
func animation_ended(_anim):
	emit_signal("cutscene_ended")
