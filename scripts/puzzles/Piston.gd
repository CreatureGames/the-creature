extends AnimatedSprite

export var target : NodePath
onready var _target : Node2D = get_node(target)
onready var _horizontal : bool = rotation_degrees == 90 or rotation_degrees == 270

func _process(_delta):
	if _horizontal:
		$Line2D.points[1].x = _target.position.x - position.x
	else:
		$Line2D.points[1].y = _target.position.y - position.y

func animate():
	if not is_playing():
		play("squish")
