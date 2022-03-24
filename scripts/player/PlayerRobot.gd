class_name PlayerRobot
extends PlayerCharacter

var has_creature := true
var drill_out := false
const MAX_BATTERY = 100
var battery_level = MAX_BATTERY setget set_battery, get_battery

onready var creature_backpack : AnimatedSprite = $CreatureBackpack
onready var launch_point : Position2D = $LauchPoint
onready var drill_offset : Vector2 = $DrillSprite.position
onready var drill_offset2 : Vector2 = $Drill.get_node("CollisionShape2D").position
onready var launch_offset : Vector2 = $LauchPoint.position
onready var emote_offset : Vector2 = Vector2.ZERO
onready var drill : KinematicBody2D = $Drill
onready var drillsprite : AnimatedSprite = $DrillSprite

var idle_timer := 0.0
const idle_timer_threshold = 5.0 # snooze for creature

export(NodePath) var creature
export var swappable := true setget set_swappable

func _ready():
	get_node(creature).visible = false
	get_node(creature).disable()
	cam.set_target(self)
	drillsprite.visible = false
	drillsprite.playing = false
	drill.disable()

func _process(delta):
	creature_backpack.visible = has_creature if swappable else false
	if idle_timer > idle_timer_threshold and creature_backpack.animation != "snooze":
		creature_backpack.play("snooze")

func store_creature():
	recharge_battery()
	has_creature = true
	get_node(creature).visible = false

func launch_creature():
	has_creature = false
	get_node(creature).visible = true
	get_node(creature).global_position = launch_point.global_position
	get_node(creature).launch()

func swap_player():
	if swappable:
		get_node(creature).enable()
		get_node(creature).visible = true
		cam.set_target(get_node(creature))
		disable()
		if has_creature:
			launch_creature()
		$SwitchAudio.play()

func rejoin_robot():
	store_creature()
	get_node(creature).swap_player()

func interact(): # called when creature interacts with robot
	rejoin_robot()

func take_damage():
	set_battery(0)
	$HurtAudio.play()

func set_battery(value):
	battery_level = clamp(value, 0, MAX_BATTERY)
	$BatteryIndicator.value = value
	if battery_level <= 0 and enabled:
		if has_creature:
			launch_creature()
		swap_player()
	
func get_battery():
	return battery_level

func recharge_battery():
	set_battery(MAX_BATTERY)
	
func set_drill_enabled(enable: bool):
	if enable:
		drillsprite.visible = true
		drill.enable()
		drillsprite.play("deploy")
		$DrillAudio.play()
	else:
		drill.disable()
		drillsprite.play("deploy", true)
		$DrillAudio.stop()
	
func drill_progress():
	if drill_out:
		if drillsprite.animation != "active":
			drillsprite.play("active")
	else:
		drillsprite.visible = false
		drillsprite.stop()

func set_facing(left: bool):
	anim.flip_h = left
	creature_backpack.flip_h = left
	anim.position.x = -spr_offset.x if left else spr_offset.x
	creature_backpack.position.x = -spr_offset.x if left else spr_offset.x
	$BatteryIndicator.rect_scale.x = -1 if left else 1
	drill.get_node("CollisionShape2D").position.x = -drill_offset2.x if left else drill_offset2.x
	drillsprite.flip_h = left
	drillsprite.position.x = -drill_offset.x if left else drill_offset.x
	$LauchPoint.position.x = -launch_offset.x if left else launch_offset.x
#	$Emote.position.x = -emote_offset.x if left else emote_offset.x

func _input(event):
	if enabled:
		if event.is_action_pressed("alt_action"):
			drill_out = not drill_out
			set_drill_enabled(drill_out)

func jump():
	.jump()
	$JumpAudio.play()

func set_swappable(can_swap : bool):
	if can_swap:
		creature_backpack.visible = true
		swappable = true
	else:
		store_creature()
		creature_backpack.visible = false
		swappable = false

func set_swappable_after(_arg0, swap:bool):
	set_swappable(swap)
