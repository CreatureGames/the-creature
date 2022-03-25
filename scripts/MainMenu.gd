extends CenterContainer

signal play_game
signal help_menu
signal credits_menu
signal exit

export var default_control : NodePath

func _ready():
	# https://docs.godotengine.org/en/latest/classes/class_os.html#class-os-get-name
	if OS.get_name() == "HTML5":
		$VBoxContainer/ExitButton.visible = false

func play_pressed():
	emit_signal("play_game")

func help_pressed():
	emit_signal("help_menu")

func credits_pressed():
	emit_signal("credits_menu")

func exit_pressed():
	emit_signal("exit")
