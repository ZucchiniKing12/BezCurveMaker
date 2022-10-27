extends Node2D
class_name BezCurve

var endpoints: Array
var anchors: Array
var curve: Curve2D

var editing: bool

var render_config = RenderConfig.new()

var color: Color setget set_color, get_color
func set_color(c):
	render_config.color = c
func get_color():
	return render_config.color
var width: float setget set_width, get_width
func set_width(c):
	render_config.width = c
func get_width():
	return render_config.width

func _ready():
	render_config.color = Color.blue
	render_config.width = 10
	render_config.name = str(OS.get_system_time_msecs())
	add_child(render_config)
	connect('curve2d_updated', render_config, '_on_curve2d_updated')
	connect('tree_exiting', render_config, '_on_curve_exiting')
	
func initialize(pos: Vector2):
	curve = Curve2D.new()
	var end1 = create_new_cpoint(pos, true)
	var end2 = create_new_cpoint(pos + Vector2(50, -50), true)
	curve.add_point(end1.position)
	curve.add_point(end2.position)
	request_render('init')
	CurveEditor.connect('editor_closed', self, 'on_editor_closed')

var PackedCPoint = preload("res://BezCurve/ControlPoint.tscn")
	
func create_new_cpoint(pos: Vector2, end: bool) -> ControlPoint:
	var newCP = PackedCPoint.instance()
	newCP.position = pos
	newCP.is_endpoint = end
	newCP.parent_curve = self
	newCP.connect("position_moved", self, "_on_position_moved")
	newCP.connect("tree_exiting_w_name", self, "_on_point_exiting")
	newCP.get_node("DragButton").connect('button_down', self, 'edit')
	if end:
		newCP.endpoint_index = len(endpoints)
		endpoints.push_back(newCP)
	else:
		anchors.push_back(newCP)
	$ControlPoints.add_child(newCP)
	curve.add_point(newCP.position, Vector2(), Vector2(), curve.get_point_count() - 1)
	update_curve2d()
	return newCP
	
func _on_point_exiting(point):
	update_curve2d()
	anchors.erase(point)
	
func _on_position_moved(_name, _new_pos):
	update_curve2d()

func edit():
	CurveEditor.close()
	CurveEditor.open()
	CurveEditor.set_curve(self)
	editing = true
	render_config.curve_editing = true
	
func on_editor_closed():
	if editing:
		editing = false
		render_config.curve_editing = false

var is_hiding

func _on_hide_points(isHiding):
	is_hiding = isHiding
	render_config.render_type = render_config.RENDER_TYPES.POINTS_HIDE if isHiding else render_config.RENDER_TYPES.IDLE
	for point in endpoints:
		point.get_node('DragButton').visible = !isHiding
	for point in anchors:
		point.get_node('DragButton').visible = !isHiding

signal curve2d_updated

func update_curve2d():
	if len(endpoints) != 2:
		return
	curve.clear_points()
	if len(anchors) == 2:
		curve.add_point(endpoints[0].position, Vector2.ZERO, anchors[0].position - endpoints[0].position)
		curve.add_point(endpoints[1].position, anchors[1].position - endpoints[1].position, Vector2.ZERO)
	if len(anchors) == 1:
		curve.add_point(endpoints[0].position, Vector2.ZERO, anchors[0].position - endpoints[0].position)
		curve.add_point(endpoints[1].position, anchors[0].position - endpoints[1].position, Vector2.ZERO)
	if len(anchors) == 0:
		curve.add_point(endpoints[0].position, Vector2.ZERO, Vector2.ZERO)
		curve.add_point(endpoints[1].position, Vector2.ZERO, Vector2.ZERO)
	emit_signal('curve2d_updated', curve)
	render_config.cpoints = endpoints + anchors
	request_render('curve2d')

var requests: Array

func request_render(reason: String):
	requests.push_back(reason)

func _on_render_config_changed():
	request_render('config')

func _process(_delta):
	render_config.render_type = render_config.RENDER_TYPES.IDLE
	
	for point in endpoints:
		if point.get_node('DragButton').is_hovered() and !editing:
			render_config.render_type = render_config.RENDER_TYPES.HOVER
	for point in anchors:
		if point.get_node('DragButton').is_hovered() and !editing:
			render_config.render_type = render_config.RENDER_TYPES.HOVER
	
	if is_hiding:
		render_config.render_type = render_config.RENDER_TYPES.POINTS_HIDE
