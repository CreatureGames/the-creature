extends CenterContainer

signal main_menu
signal play_level

export var app : NodePath
export var buttons_container : NodePath
var _app : Node
var _buttons: Array
var _selected_level : int

func _ready():
	_app = get_node(app)
	_selected_level = -1
	_buttons = get_node(buttons_container).get_children()
	for i in range(_buttons.size()):
		_buttons[i].connect("pressed", self, "select_level", [i + 1])

# disable levels that aren't unlocked
func init_buttons():
	var unlocked_level = _app.load_level_num()
	for i in range(_buttons.size()):
		_buttons[i].disabled = i >= unlocked_level
	$VBoxContainer/HBoxContainer2/PlayButton.disabled = true

func select_level(level : int):
	_selected_level = level
	$VBoxContainer/HBoxContainer2/PlayButton.disabled = false

func menu_pressed():
	emit_signal("main_menu")

func play_pressed():
	emit_signal("play_level", _selected_level)
