extends AnimatedSprite

signal pressed
signal released

var is_pressed = false

func press():
	if not is_pressed:
		emit_signal("pressed")
		is_pressed = true
		frame = 0
		play("press")
		$PressAudio.play()

func release():
	if $Interactable.partners.empty():
		is_pressed = false
		emit_signal("released")
		play("release")
		$ReleaseAudio.play()
