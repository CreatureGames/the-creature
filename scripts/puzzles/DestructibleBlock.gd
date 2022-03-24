extends StaticBody2D

func drill_hit():
	die()

func die():
	var part = $BlockBreakParticles
	part.visible = true
	self.remove_child(part)
	get_parent().add_child(part)
	part.global_position = global_position + Vector2(8,8)
	part.restart()
	$CollisionShape2D.disabled = true
	$Sprite.visible = false
	$BreakAudio.play()
	$BreakAudio.connect("finished", self, "queue_free")
