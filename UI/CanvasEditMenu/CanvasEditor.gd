extends VBoxContainer

onready var color_set_button = $ColorSet/Manage/Button
onready var color_picker = $ColorSet/ColorPicker
onready var color_preview = $ColorSet/Manage/ColorRect

var canvas_color := Color(220 / 255, 10 / 255, 60 / 255, 1)

signal canvas_changed

func _ready():
	color_set_button.connect("pressed", self, '_on_ColorSetButton_pressed')
	if get_tree().get_root().get_node('Main'):
		connect('canvas_changed', get_tree().get_root().get_node('Main'), '_on_canvas_changed')
	emit_signal("canvas_changed", canvas_color)
	
func _process(_delta):
	if color_picker.visible:
		canvas_color = color_picker.color
		emit_signal("canvas_changed", canvas_color)
	color_preview.color = canvas_color

func _on_ColorSetButton_pressed():
	color_picker.visible = not color_picker.visible
	color_set_button.text = 'Choose canvas color' if not color_picker.visible else 'Done'
