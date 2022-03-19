# Run.gd
extends PlayerState


func physics_update(delta: float) -> void:
	# Notice how we have some code duplication between states. That's inherent to the pattern,
	# although in production, your states will tend to be more complex and duplicate code
	# much more rare.
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return

	# We move the run-specific input code to the state.
	# A good alternative would be to define a `get_input_direction()` function on the `Player.gd`
	# script to avoid duplicating these lines in every script.
	var input_direction_x: float = player.get_input_direction()
	
	# accelerate
	if not is_equal_approx(input_direction_x, 0.0):
		player.velocity.x = clamp(player.velocity.x + (player.acceleration * input_direction_x), -player.max_speed, player.max_speed)
	# decelerate
	else:
		player.velocity.x = sign(player.velocity.x) * clamp((abs(player.velocity.x) - player.ground_friction), 0, player.max_speed)
	
	# gravity
	player.velocity.y += player.gravity * delta
	
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {do_jump = true})
	elif is_equal_approx(input_direction_x, 0.0) and is_equal_approx(player.velocity.x, 0.0):
		state_machine.transition_to("Idle")
