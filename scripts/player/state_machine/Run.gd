# Run.gd
extends PlayerState

func enter(msg := {}) -> void:
	if msg.has("jump_buffered"):
		state_machine.transition_to("Air", {do_jump = true})

func physics_update(delta: float) -> void:
	# Notice how we have some code duplication between states. That's inherent to the pattern,
	# although in production, your states will tend to be more complex and duplicate code
	# much more rare.
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return

	var input_direction: Vector2 = player.get_input_direction()
	var accel_x : Vector2
	if not is_equal_approx(input_direction.x, 0.0):
		accel_x = player.acceleration * input_direction
	else:
		accel_x = -sign(player.velocity.x) * player.ground_friction * Vector2.RIGHT
		# handle stopping due to friction
		if sign(player.velocity.x + accel_x.x*delta) * sign(player.velocity.x) < 0: #change in direction
			if not is_zero_approx(delta):
				accel_x.x = -player.velocity.x / delta
	
	# movement & gravity
	player.velocity += (player.gravity + accel_x) * delta
	player.velocity.x = sign(player.velocity.x) * clamp(abs(player.velocity.x), 0, player.max_speed)
	player.velocity.y = sign(player.velocity.y) * clamp(abs(player.velocity.y), 0, player.max_fall_speed)
	
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {do_jump = true})
	elif is_equal_approx(input_direction.x, 0.0) and is_equal_approx(player.velocity.x, 0.0):
		state_machine.transition_to("Idle")
