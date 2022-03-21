class_name PlayerCharacter
extends KinematicBody2D

export var max_speed := 120.0
export var jump_height := 35.0
export var jump_apex_time := 0.3

export var acceleration := 500.0
export var ground_friction := 500.0
export var air_friction := 50.0
export var max_fall_speed := 500.0

var velocity := Vector2.ZERO
var airtime := 0.0

var jump_speed : float
var gravity : Vector2

onready var anim : AnimatedSprite = $AnimatedSprite
onready var spr_offset : Vector2 = $AnimatedSprite.offset

func _ready():
	recalc_physics()

func get_input_direction() -> Vector2:
	return (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * Vector2.RIGHT

func jump():
	velocity.y = -jump_speed
	
func recalc_physics():
	jump_speed = 2 * jump_height / jump_apex_time
	gravity = 2 * jump_height / (pow(jump_apex_time, 2)) * Vector2.DOWN
