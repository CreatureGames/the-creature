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
	anim.offset.x = -spr_offset.x if left else spr_offset.x
