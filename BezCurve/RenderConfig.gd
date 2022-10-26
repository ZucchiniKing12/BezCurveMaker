extends Node
class_name RenderConfig

enum RENDER_TYPES {IDLE, HOVER, EDIT}

export var render_type = RENDER_TYPES.IDLE setget set_render_type
func set_render_type(type):
	request_change('render_type', type, render_type)
	render_type = type
	
var active = true

func _on_curve_exiting():
	request_change('active', true, false)
	active = false
	emit_signal("tree_exiting", name)

func _on_curve2d_updated(curve2d: Curve2D):
	set_points(curve2d.tessellate(6))

var points: PoolVector2Array setget set_points
func set_points(p: PoolVector2Array):
	request_change('points', p, points)
	points = p

var color: Color setget set_color
func set_color(c: Color):
	request_change('color', c, color)
	color = c
	
var width: float setget set_width
func set_width(w):
	request_change('width', w, width)
	width = w

var requests := Array()

signal render_config_changed

func request_change(_type, _new, _old):
	emit_signal('render_config_changed')

func _process(_delta):
	print(render_type)
