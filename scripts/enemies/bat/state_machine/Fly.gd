extends State


func enter(_msg := {}) -> void:
	get_node("../../AnimatedSprite").play("flap")
	get_node("../../AttackTimer").start()
