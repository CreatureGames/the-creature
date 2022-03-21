extends KinematicBody2D


export var nav2D : NodePath

export var follow_speed : int
export var attack_speed : int

onready var nav : Navigation2D = get_node(nav2D)
var players : Array = []


# someone's near...
func detection_zone_entered(body) -> void:
	players.append(body)
	# wake up if sleeping
	if $StateMachine.state.name == "Idle":
		$StateMachine.transition_to("Fly")

func detection_zone_exited(body) -> void:
	players.erase(body)
	if players.empty():
		$StateMachine.transition_to("Idle")
