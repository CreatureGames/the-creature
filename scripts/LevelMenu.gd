extends CenterContainer

signal main_menu
signal play_level

export var default_control : NodePath
export var app : NodePath
export var buttons_container : NodePath
export(Color, RGB) var select_color : Color
var _app : Node
var _buttons: Array
var _selected_level : int

func _ready():
	_app = get_node(app)
	_selected_level = -1
	_buttons = get_node(buttons_container).get_children()
	for i in range(_buttons.size()):
		_buttons[i].connect("pressed", self, "select_level", [_buttons[i], i + 1])

# disable levels that aren't unlocked
func init_buttons():
	var unlocked_level = _app.load_level_num()
	for i in range(_buttons.size()):
		_buttons[i].disabled = i >= unlocked_level
		_buttons[i].modulate = Color.white
	$VBoxContainer/HBoxContainer2/PlayButton.disabled = true

func select_level(button : Button, level : int):
	for b in _buttons:
		if b == button:
			b.modulate = select_color
		else:
			b.modulate = Color.white
	_selected_level = level
	$VBoxContainer/HBoxContainer2/PlayButton.disabled = false

func menu_pressed():
	emit_signal("main_menu")

func play_pressed():
	emit_signal("play_level", _selected_level)
