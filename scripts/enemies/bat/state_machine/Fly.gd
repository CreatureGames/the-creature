extends EnemyState

var path : Array = []


func enter(_msg := {}) -> void:
	enemy.anim.play("flap")

func physics_update(delta: float) -> void:
	if not enemy.players.empty():
		# https://godotengine.org/asset-library/asset/117
		var target_pos = enemy.players[0].position
		target_pos.y -= enemy.target_y_offset # fly over player before attack
		_update_navigation_path(enemy.position, target_pos)
		var dist = enemy.follow_speed * delta
		move_along_path(dist)
		
		# attack!
		if abs(enemy.position.x - target_pos.x) < enemy.attack_x_threshold:
			if enemy.get_node("AttackTimer").is_stopped():
				enemy.get_node("AttackTimer").start()
		else:
			enemy.get_node("AttackTimer").stop()

func exit() -> void:
	enemy.get_node("AttackTimer").stop()

# https://godotengine.org/asset-library/asset/117
func move_along_path(distance):
	var last_point = enemy.position
	while path.size():
		var distance_between_points = last_point.distance_to(path[0])
		# The position to move to falls between two points.
		if distance <= distance_between_points:
			enemy.position = last_point.linear_interpolate(path[0], distance / distance_between_points)
			return
		# The position is past the end of the segment.
		distance -= distance_between_points
		last_point = path[0]
		path.remove(0)
	# The character reached the end of the path.
	enemy.position = last_point
	set_process(false)

# https://godotengine.org/asset-library/asset/117
func _update_navigation_path(start_position, end_position):
	path = enemy.nav.get_simple_path(start_position, end_position, true)
	path.remove(0)
	set_process(true)
