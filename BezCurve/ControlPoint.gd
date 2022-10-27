extends Position2D
class_name ControlPoint

var is_endpoint = false
var endpoint_index = -1
var parent_curve

const edit_texture = preload("res://BezCurve/point.png")
const idle_texture = preload("res://BezCurve/small_point.png")

signal tree_exiting_w_name

func _ready():
	$DragButton.connect("button_down", self, '_on_button_down')
	$DragButton.connect("button_up", self, '_on_button_up')
	
func _exit_tree():
	emit_signal('tree_exiting_w_name', self)

func _process(_delta):
	if editing():
		position = get_global_mouse_position()
		emit_signal('position_moved', name, position)

func label():
	return ('Endpoint' if is_endpoint else 'Point')

var dragging: bool
signal position_moved

func editing():
	return dragging and parent_curve.editing

func _on_button_down():
	dragging = true
	
func _on_button_up():
	dragging = false
