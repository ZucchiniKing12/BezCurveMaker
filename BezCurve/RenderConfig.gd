extends Node
class_name RenderConfig

enum RENDER_TYPES {IDLE, HOVER, EDIT}

export var curve_editing = false setget set_curve_editing
func set_curve_editing(ce):
	request_change()
	curve_editing = ce

export var render_type = RENDER_TYPES.IDLE setget set_render_type
func set_render_type(type):
	request_change()
	render_type = type
	
var active = true
signal deactivate

func _on_curve_exiting():
	request_change()
	active = false
	emit_signal('deactivate', name)
	queue_free()

func _on_curve2d_updated(curve2d: Curve2D):
	set_points(curve2d.tessellate(6))

var points: PoolVector2Array setget set_points
func set_points(p: PoolVector2Array):
	request_change()
	points = p

var color: Color setget set_color
func set_color(c: Color):
	request_change()
	color = c
	
var width: float setget set_width
func set_width(w):
	request_change()
	width = w

var requests := Array()

signal render_config_changed

func request_change():
	emit_signal('render_config_changed')
