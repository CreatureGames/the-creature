extends KinematicBody2D


const STATE_IDLE		= 0
const STATE_FLYING		= 1
const STATE_ATTACK_BR	= 2 # "broadcast" portion of attack
const STATE_ATTACK_DR	= 3 # "drop" portion of attack

var cur_state : int = STATE_IDLE


# someone's near...
func detection_zone_entered(area) -> void:
	# wake up
	if cur_state == STATE_IDLE:
		change_state(STATE_FLYING)
	# attack
	elif cur_state == STATE_FLYING:
		pass # TODO

# change state & animation...
func change_state(new_state: int) -> void:
	cur_state = new_state
	$AnimatedSprite.play("")
