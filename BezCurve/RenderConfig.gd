extends Node
class_name RenderConfig

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

func request_change(type, new, old):
	emit_signal('render_config_changed')
