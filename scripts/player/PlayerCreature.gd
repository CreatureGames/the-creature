class_name PlayerCreature
extends PlayerCharacter

export(NodePath) var robot

func launch():
	$StateMachine.transition_to("Air", {do_jump = true})

func swap_player():
	if get_node(robot).battery_level > 0:
		get_node(robot).enable()
		cam.set_target(get_node(robot))
		disable()

func set_facing(left: bool):
	anim.flip_h = left
	anim.position.x = -spr_offset.x if left else spr_offset.x

func disable():
	.disable()
	if not visible:
		var interactable : CollisionObject2D = get_node("Interactable")
		if interactable:
			interactable.set_collision_layer_bit(2, false)
			interactable.set_collision_mask_bit(2, false)

func enable():
	.enable()
	var interactable : CollisionObject2D = get_node("Interactable")
	if interactable:
		interactable.set_collision_layer_bit(2, true)
		interactable.set_collision_mask_bit(2, true)
