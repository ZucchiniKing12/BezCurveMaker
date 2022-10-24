extends Node2D
class_name BezCurve

var endpoints: Array
var anchors: Array
var curve: Curve2D

var render_config = RenderConfig.new()

func _ready():
	$EditButton.connect('pressed', self, 'edit')
	render_config.color = Color.blue
	render_config.width = 10
	render_config.connect('render_config_changed', self, '_on_render_config_changed')
	
func _process(delta):
	if len(requests) > 0:
		var latest_req = requests[len(requests) - 1]
		emit_signal("request_render", latest_req, self)
		requests.pop_back()

func initialize(pos: Vector2):
	curve = Curve2D.new()
	var end1 = create_new_cpoint(pos, true)
	var end2 = create_new_cpoint(pos + Vector2(50, -50), true)
	curve.add_point(end1.position)
	curve.add_point(end2.position)
	request_render('init')
	update_button()

var PackedCPoint = preload("res://BezCurve/ControlPoint.tscn")
	
func create_new_cpoint(pos: Vector2, end: bool) -> ControlPoint:
	var newCP = PackedCPoint.instance()
	newCP.position = pos
	newCP.is_endpoint = end
	if end:
		newCP.endpoint_index = len(endpoints)
		endpoints.push_back(newCP)
	else:
		anchors.push_back(newCP)
	$ControlPoints.add_child(newCP)
	curve.add_point(newCP.position, Vector2(), Vector2(), curve.get_point_count() - 1)
	update_curve2d()
	return newCP

func edit():
	CurveEditor.close()
	CurveEditor.open()
	CurveEditor.set_curve(self)

func update_button():
	$EditButton.set_position(Vector2(min(endpoints[0].position.x, endpoints[1].position.x), min(endpoints[0].position.y, endpoints[1].position.y)))
	$EditButton.set_size(Vector2(abs(endpoints[0].position.x - endpoints[1].position.x), abs(endpoints[0].position.y - endpoints[1].position.y)))

func update_curve2d():
	curve.clear_points()
	for n in endpoints:
		curve.add_point(n.position)
	for n in len(anchors):
		var prev = endpoints[0] if n == 0 else anchors[n - 1]
		var next = endpoints[1] if n == len(anchors) - 1 else anchors[n + 1]
		curve.add_point(anchors[n].position, prev.position, next.position, curve.get_point_count() - 1)
	request_render('curve2d')

signal request_render

var requests: Array

func request_render(reason: String):
	requests.push_back(reason)

func _on_render_config_changed(change):
	request_render('config')
