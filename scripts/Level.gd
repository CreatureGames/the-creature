extends Node2D

signal completed

func disable_level_end(scene: String = ""):
	$LevelEnd.set_collision_layer_bit(0, false)
	$LevelEnd.set_collision_mask_bit(0, false)

func enable_level_end(scene: String = ""):
	$LevelEnd.set_collision_layer_bit(0, true)
	$LevelEnd.set_collision_mask_bit(0, true)
