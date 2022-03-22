extends EnemyState

func enter(_msg := {}) -> void:
	enemy.anim.play("attack-broadcast")
	enemy.anim.connect("animation_finished", self, "drop")
	
func drop():
	state_machine.transition_to("Attack")
	enemy.anim.disconnect("animation_finished", self, "drop")
