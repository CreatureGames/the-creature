class_name PlayerCreature
extends PlayerCharacter

export(NodePath) var robot

func launch():
	$StateMachine.transition_to("Air", {do_jump = true})

func swap_player():
	get_node(robot).enable()
	disable()
