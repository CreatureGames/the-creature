extends KinematicBody2D


export var follow_speed : int
export var attack_speed : int


# someone's near...
func detection_zone_entered(area) -> void:
	# wake up if sleeping
	if $StateMachine.state.name == "Idle":
		$StateMachine.transition_to("Fly")
