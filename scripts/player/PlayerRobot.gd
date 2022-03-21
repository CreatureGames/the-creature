class_name PlayerRobot
extends PlayerCharacter

var has_creature := true
var drill_out := false

onready var creature_backpack : AnimatedSprite = $CreatureBackpack
onready var launch_point : Position2D = $LauchPoint

var idle_timer := 0.0
const idle_timer_threshold = 5.0 # snooze for creature

func _process(delta):
	creature_backpack.visible = has_creature
	if idle_timer > idle_timer_threshold and creature_backpack.animation != "snooze":
		creature_backpack.play("snooze")
