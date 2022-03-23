extends Enemy


export var nav2D : NodePath

export var target_y_offset : int
export var attack_x_threshold : int
export var follow_speed : int
export var attack_speed : int

onready var nav : Navigation2D = get_node(nav2D)
onready var anim = $AnimatedSprite
var players : Array = []

func _physics_process(delta):
	for p in in_damage_area:
		if p.has_method("take_damage") and $StateMachine.state == $StateMachine/Attack:
			p.take_damage()

# someone's near...
func detection_zone_entered(body) -> void:
	players.append(body)
	# wake up if sleeping
	if $StateMachine.state.name == "Idle":
		$StateMachine.transition_to("Follow")

# someone's far...
func detection_zone_exited(body) -> void:
	players.erase(body)
	if players.empty():
		$StateMachine.transition_to("FlyToCeiling")

func drill_hit():
	die()

func die():
	queue_free()
