# Air.gd
extends PlayerState

const coyote_jump_threshold := 0.05 # 3 frames @ 60fps

# If we get a message asking us to jump, we jump.
func enter(msg := {}) -> void:
	if msg.has("do_jump"):
		player.jump()

func update(delta):
	player.airtime += delta

func physics_update(delta: float) -> void:
	
	var input_direction_x: float = player.get_input_direction()
	
	# accelerate
	if not is_equal_approx(input_direction_x, 0.0):
		player.velocity.x = clamp(player.velocity.x + (player.acceleration * input_direction_x), -player.max_speed, player.max_speed)
	# decelerate
	else:
		player.velocity.x = sign(player.velocity.x) * (abs(player.velocity.x) - player.air_friction)
	
	# "coyote jumping" for a couple frames after leaving a ledge
	if Input.is_action_just_pressed("jump") and player.airtime <= coyote_jump_threshold:
		player.jump()
	
	# gravity
	player.velocity.y += player.gravity * delta
	
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

	# Landing.
	if player.is_on_floor():
		player.airtime = 0.0
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
