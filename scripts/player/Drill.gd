extends KinematicBody2D

func _physics_process(delta):
	var coll = move_and_collide(Vector2.ZERO, true, true, true)
	if coll:
		if coll.collider.has_method("drill_hit"):
			coll.collider.drill_hit()
			owner.velocity.x *= 0.2
			if coll.collider is StaticBody2D:
				owner.velocity.x = 0
