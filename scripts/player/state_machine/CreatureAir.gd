# Air.gd
extends PlayerState

const coyote_jump_threshold := 0.05 # 3 frames @ 60fps
const jump_buffer_threshold := 0.05

var jump_pressed := false
var time_since_jump_pressed := 0.0 # for jump buffering

# If we get a message asking us to jump, we jump.
func enter(msg := {}) -> void:
	if msg.has("do_jump"):
		player.jump()
		player.anim.play("jump")

func update(delta):
	var input_direction: Vector2 = player.get_input_direction()
	
	player.airtime += delta
	if jump_pressed:
		time_since_jump_pressed += delta
		
	# animations
	if player.velocity.y > 0 and player.anim.animation != "fall":
		player.anim.play("fall")
	if not is_equal_approx(input_direction.x, 0.0):
		player.set_facing(input_direction.x < 0.0)

func physics_update(delta: float) -> void:
	
	var input_direction: Vector2 = player.get_input_direction()
	var accel_x : Vector2
	if not is_equal_approx(input_direction.x, 0.0):
		accel_x = player.acceleration * input_direction
	else:
		accel_x = -sign(player.velocity.x) * player.air_friction * Vector2.RIGHT
	
	# movement & gravity
	player.velocity += (player.gravity + accel_x) * delta
	player.velocity.x = sign(player.velocity.x) * clamp(abs(player.velocity.x), 0, player.max_speed)
	player.velocity.y = sign(player.velocity.y) * clamp(abs(player.velocity.y), 0, player.max_fall_speed)
	
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	# "coyote jumping" for a couple frames after leaving a ledge
	if Input.is_action_just_pressed("jump"):
		if player.airtime <= coyote_jump_threshold:
			player.jump()
		else:
			jump_pressed = true
			time_since_jump_pressed = 0.0

	# Landing.
	if player.is_on_floor():
		player.airtime = 0.0
		var msg = {from_air = true}
		if time_since_jump_pressed <= jump_buffer_threshold and jump_pressed:
			msg = {jump_buffered = true}
			
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle", msg)
		else:
			state_machine.transition_to("Run", msg)
