extends Position2D
class_name ControlPoint

var is_endpoint = false
var endpoint_index = -1
var parent_curve

var t1 = preload("res://BezCurve/point.png")
var t2 = preload("res://BezCurve/small_point.png")

func _ready():
	$DragButton.connect("button_down", self, '_on_button_down')
	$DragButton.connect("button_up", self, '_on_button_up') 

func _process(_delta):
	$DragButton.icon = t1 if is_endpoint else t2
	
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
