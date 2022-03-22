extends State


onready var bat : Node2D = get_parent().get_parent()


func enter(_msg := {}) -> void:
	bat.get_node("AnimatedSprite").play("flap")

# fly to ceiling to go back to sleep
func physics_update(delta: float) -> void:
	var collision = bat.move_and_collide(Vector2.UP * bat.follow_speed * delta)
	if collision and collision.collider is TileMap:
		get_parent().transition_to("Idle")
