extends KinematicBody2D


# someone's near...
func detection_zone_entered(area) -> void:
	# wake up if sleeping
	if $StateMachine.state.name == "Idle":
		$StateMachine.transition_to("Fly")
