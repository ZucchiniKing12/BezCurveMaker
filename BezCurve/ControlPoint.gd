extends Position2D
class_name ControlPoint

var is_endpoint = false
var endpoint_index = -1
var parent_curve

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
	var button_width = parent_curve.render_config.width * 1.5 + 4
	$DragButton.rect_position = Vector2(-1 * button_width, -1 * button_width)
	$DragButton.rect_size = Vector2(2 * button_width, 2 * button_width)

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
