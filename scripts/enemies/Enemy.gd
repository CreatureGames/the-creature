class_name Enemy
extends KinematicBody2D

var in_damage_area : Array = []

func player_enter_damage(body):
	in_damage_area.append(body)
	
func player_exit_damage(body):
	in_damage_area.erase(body)
