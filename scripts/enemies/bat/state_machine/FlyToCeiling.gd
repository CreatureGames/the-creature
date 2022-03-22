extends EnemyState

func enter(_msg := {}) -> void:
	enemy.anim.play("flap")

# fly to ceiling to go back to sleep
func physics_update(delta: float) -> void:
	var collision = enemy.move_and_collide(Vector2.UP * enemy.follow_speed * delta)
	if collision and collision.collider is TileMap:
		state_machine.transition_to("Idle")
