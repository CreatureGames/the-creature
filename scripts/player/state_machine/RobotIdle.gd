# Idle.gd
extends PlayerState

# Upon entering the state, we set the Player node's velocity to zero.
func enter(msg := {}) -> void:
	player.idle_timer = 0.0
	if msg.has("jump_buffered"):
		state_machine.transition_to("Air", {do_jump = true})
	else:
		player.velocity = Vector2.ZERO
		if msg.has("from_air"):
			player.anim.play("land")
			player.creature_backpack.play("land")
		else:
			player.anim.play("idle")
			player.creature_backpack.play("idle")

func update(delta: float) -> void:
	player.idle_timer += delta

func anim_finish():
	if player.anim.animation != "idle" and state_machine.state == self:
		player.anim.play("idle")
		player.creature_backpack.play("idle")

func physics_update(_delta: float) -> void:
	# If you have platforms that break when standing on them, you need that check for 
	# the character to fall.
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return

	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {do_jump = true})
		
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine.transition_to("Run")
