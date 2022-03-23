extends Node2D

onready var bubble : AnimatedSprite = $Bubble
onready var emote  : AnimatedSprite = $Emote

func emote(name : String):
	bubble.animation = "bubble_out"
	emote.animation = name
	bubble.stop()
	emote.stop()
	_pop_out_bubble()
	
func flip(left : bool):
	scale.x = -1 if left else 1
	emote.flip_h = left
	emote.offset.x = 1 if left else 0
	
func bubble_anim_finished():
	if bubble.animation == "bubble_out":
		_show_emote_image()
	elif bubble.animation == "bubble_in":
		visible = false
	
func emote_anim_finished():
	emote.visible = false
	_pop_in_bubble()
	
func _pop_out_bubble():
	visible = true
	emote.visible = false
	bubble.play("bubble_out")
	
func _pop_in_bubble():
	bubble.play("bubble_in")
	
func _show_emote_image():
	bubble.animation = "bubble"
	bubble.frame = 0
	bubble.stop()
	emote.visible = true
	emote.frame = 0
	emote.play()
