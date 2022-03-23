extends KinematicBody2D

onready var coll_layer = collision_layer
onready var coll_mask = collision_mask

func _physics_process(delta):
	var coll = move_and_collide(Vector2.ZERO, true, true, true)
	if coll:
		if coll.collider.has_method("drill_hit"):
			coll.collider.drill_hit()
			owner.velocity.x *= 0.2
			if coll.collider is StaticBody2D:
				owner.velocity.x = 0

func enable():
	collision_layer = coll_layer
	collision_mask = coll_mask
	
func disable():
	collision_layer = 0
	collision_mask = 0
