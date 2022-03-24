extends Node2D

signal completed

func disable_level_end(scene: String = ""):
	$LevelEnd.set_collision_layer_bit(0, false)
	$LevelEnd.set_collision_mask_bit(0, false)

func enable_level_end(scene: String = ""):
	$LevelEnd.set_collision_layer_bit(0, true)
	$LevelEnd.set_collision_mask_bit(0, true)

func find_easter_egg():
	var par = get_parent()
	if not par is Viewport:
		get_parent().found_easter_egg = true
