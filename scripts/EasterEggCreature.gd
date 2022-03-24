extends Node2D

signal easter_egg_found

func _ready():
	$AnimatedSprite.stop()
	var time = rand_range(0.0, 1.0)
	yield(get_tree().create_timer(time), "timeout")
	$AnimatedSprite.play()

func _find_easter_egg(_body):
	emit_signal("easter_egg_found")
