extends VBoxContainer

var in_curve_mode := true

onready var CURVE_EDITOR = get_node('CurveEditor')
onready var CANVAS_EDITOR = get_node('CanvasEditor')

func _ready():
	$Buttons/CurveMode.connect('toggled', self, '_on_CurveMode_toggled')
	$Buttons/CanvasMode.connect('toggled', self, '_on_CanvasMode_toggled')
	$Buttons/CurveMode.pressed = true
	
	if !CURVE_EDITOR:
		add_child(load('res://UI/EditMenu/CurveEditor.tscn').instance())
	if !CANVAS_EDITOR:
		add_child(load('res://UI/CanvasEditMenu/CanvasEditor.tscn').instance())

func _on_CurveMode_toggled(val):
	in_curve_mode = val
	$Buttons/CanvasMode.set_pressed_no_signal(not val)
	CURVE_EDITOR.visible = val
	CANVAS_EDITOR.visible = not val
	
func _on_CanvasMode_toggled(val):
	in_curve_mode = not val
	$Buttons/CurveMode.set_pressed_no_signal(not val)
	CURVE_EDITOR.visible = not val
	CANVAS_EDITOR.visible = val
