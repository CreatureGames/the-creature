extends StaticBody2D

func drill_hit():
	die()

func die():
	$CollisionShape2D.disabled = true
	$BreakAudio.play()
	$BreakAudio.connect("finished", self, "queue_free")
