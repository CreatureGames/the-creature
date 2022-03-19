class_name Player
extends KinematicBody2D

export var max_speed := 120.0
export var jump_height := 64.0
export var jump_apex_time := 0.3

onready var jump_speed := 2 * jump_height / jump_apex_time
onready var gravity := 2 * jump_height / (pow(jump_apex_time, 2))

export var acceleration := 10.0
export var ground_friction := 10.0
export var air_friction := 10.0

var velocity := Vector2.ZERO

var airtime := 0.0

func _ready():
	pass

func get_input_direction() -> float:
	return Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

func jump():
	velocity.y = -jump_speed

func move_verlet(rel_vec: Vector2, delta: float):
	#only use this in a _physics_process() method
	var d = velocity * delta + 0.5 * gravity * delta * delta * Vector2.DOWN
	velocity += gravity * delta * Vector2.DOWN
	var coll : KinematicCollision2D = move_and_collide(d)
	while coll != null:
		coll = move_and_collide(coll.remainder)
