extends EnemyState


func enter(_msg := {}) -> void:
	enemy.anim.play("idle")
