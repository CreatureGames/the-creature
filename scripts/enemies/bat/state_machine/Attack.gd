extends State

onready var anim_sprite = get_node("../../AnimatedSprite")

func enter(_msg := {}) -> void:
	print("Attack started")
	anim_sprite.play("attack-broadcast")
	anim_sprite.connect("animation_finished", self, "drop")

func drop():
	anim_sprite.play("attack-broadcast")
	anim_sprite.disconnect("animation_finished", self, "drop")

func exit() -> void:
	for c in anim_sprite.get_signal_connection_list("animation_finished"):
		anim_sprite.disconnect(c["signal"], c["target"], c["method"])
