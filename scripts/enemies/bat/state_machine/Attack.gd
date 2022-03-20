extends State

onready var bat = get_node("../..")
onready var anim_sprite = bat.get_node("AnimatedSprite")
var dropping : bool

func enter(_msg := {}) -> void:
	dropping = false
	anim_sprite.play("attack-broadcast")
	anim_sprite.connect("animation_finished", self, "drop")

func drop():
	dropping = true
	anim_sprite.play("attack-broadcast")
	anim_sprite.disconnect("animation_finished", self, "drop")

func physics_update(delta: float) -> void:
	if dropping:
		var collision = bat.move_and_collide(Vector2.DOWN * bat.attack_speed * delta)
		if collision:
			if collision.collider.name == "Player":
				print("Player hit!") # TODO damage or something
			get_parent().transition_to("Fly")

func exit() -> void:
	for c in anim_sprite.get_signal_connection_list("animation_finished"):
		anim_sprite.disconnect(c["signal"], c["target"], c["method"])
