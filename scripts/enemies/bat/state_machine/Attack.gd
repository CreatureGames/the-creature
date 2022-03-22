extends EnemyState

func enter(_msg := {}) -> void:
	enemy.anim.play("attack-drop")
	enemy.get_node("AttackTimer").start()

func physics_update(delta: float) -> void:
	var collision = enemy.move_and_collide(Vector2.DOWN * enemy.attack_speed * delta)
	if collision:
		state_machine.transition_to("Follow")

func timer_timeout():
	if state_machine.state == self:
		state_machine.transition_to("Follow")

func exit() -> void:
	for c in enemy.anim.get_signal_connection_list("animation_finished"):
		enemy.anim.disconnect(c["signal"], c["target"], c["method"])
