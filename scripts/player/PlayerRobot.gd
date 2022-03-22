class_name PlayerRobot
extends PlayerCharacter

var has_creature := true
var drill_out := false
var battery_level = 100 setget set_battery, get_battery

onready var creature_backpack : AnimatedSprite = $CreatureBackpack
onready var launch_point : Position2D = $LauchPoint

var idle_timer := 0.0
const idle_timer_threshold = 5.0 # snooze for creature

export(NodePath) var creature

func _ready():
	get_node(creature).visible = false
	get_node(creature).disable()
	cam.set_target(self)

func _process(delta):
	creature_backpack.visible = has_creature
	if idle_timer > idle_timer_threshold and creature_backpack.animation != "snooze":
		creature_backpack.play("snooze")

func store_creature():
	has_creature = true
	get_node(creature).visible = false

func launch_creature():
	has_creature = false
	get_node(creature).visible = true
	get_node(creature).global_position = launch_point.global_position
	get_node(creature).launch()

func swap_player():
	get_node(creature).enable()
	get_node(creature).visible = true
	cam.set_target(get_node(creature))
	disable()
	if has_creature:
		launch_creature()

func interact(): # called when creature interacts with robot
	store_creature()
	get_node(creature).swap_player()

func take_damage():
	set_battery(battery_level - 1)

func set_battery(value):
	battery_level = clamp(value, 0, 100)
	$BatteryIndicator.value = value
	
func get_battery():
	return battery_level
