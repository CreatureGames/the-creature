extends State


onready var bat : Node2D = get_parent().get_parent()
var path : Array = []


func enter(_msg := {}) -> void:
	get_node("../../AnimatedSprite").play("flap")
	get_node("../../AttackTimer").start()

# https://godotengine.org/asset-library/asset/117
func physics_update(delta: float) -> void:
	if not bat.players.empty():
		_update_navigation_path(bat.position, bat.players[0].position)
		var dist = bat.follow_speed * delta
		move_along_path(dist)

# https://godotengine.org/asset-library/asset/117
func move_along_path(distance):
	var last_point = bat.position
	while path.size():
		var distance_between_points = last_point.distance_to(path[0])
		# The position to move to falls between two points.
		if distance <= distance_between_points:
			bat.position = last_point.linear_interpolate(path[0], distance / distance_between_points)
			return
		# The position is past the end of the segment.
		distance -= distance_between_points
		last_point = path[0]
		path.remove(0)
	# The character reached the end of the path.
	bat.position = last_point
	set_process(false)

# https://godotengine.org/asset-library/asset/117
func _update_navigation_path(start_position, end_position):
	path = bat.nav.get_simple_path(start_position, end_position, true)
	path.remove(0)
	set_process(true)
