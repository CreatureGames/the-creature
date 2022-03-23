# Idle.gd
extends PlayerState

# Upon entering the state, we set the Player node's velocity to zero.
func enter(msg := {}) -> void:
	if msg.has("jump_buffered"):
		state_machine.transition_to("Air", {do_jump = true})
	else:
		player.velocity = Vector2.ZERO
		if msg.has("from_air"):
			player.anim.play("land")
		else:
			player.anim.play("idle")

func anim_finish():
	if player.enabled:
		if player.anim.animation != "idle" and state_machine.state == self:
			player.anim.play("idle")
	elif player.anim.animation != "sit":
		player.anim.play("sit")

func physics_update(delta: float) -> void:
	# If you have platforms that break when standing on them, you need that check for 
	# the character to fall.
	player.velocity += (player.gravity) * delta
	player.velocity.y = sign(player.velocity.y) * clamp(abs(player.velocity.y), 0, player.max_fall_speed)
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	if player.enabled:
		if Input.is_action_just_pressed("jump"):
			state_machine.transition_to("Air", {do_jump = true})
			
		elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			state_machine.transition_to("Run")
