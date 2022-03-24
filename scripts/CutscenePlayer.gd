extends AnimationPlayer

export var cutscene := "IntroCutscene"
var played = false

func enter_trigger(body):
	if body is PlayerRobot and not played:
		play_cutscene(cutscene)
		played = true

func play_cutscene(scene: String):
	play(scene)
