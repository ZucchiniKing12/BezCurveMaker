extends Node2D

func _ready():
	# add the editor as a child so we can see it in the viewport
	add_child(CurveEditor)
	CurveEditor.set_position(Vector2(get_viewport().size.x - 300, 0))
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.doubleclick and !is_mouse_over_editor():
			CurveEditor.close()
			create_new_curve(event.position)

var PackedBezcurve = preload("res://BezCurve/BezCurve.tscn")

func create_new_curve(pos: Vector2) -> BezCurve:
	var newcurve = PackedBezcurve.instance()
	newcurve.initialize(pos)
	$Curves.add_child(newcurve)
	newcurve.connect('request_render', self, '_on_request_render')
	return newcurve

func _on_request_render(reason: String, curve: BezCurve):
	requests.push_back(
		{ 
			'points': curve.curve.tessellate(7), 
			'color': curve.render_config.color,
			'width': curve.render_config.width
		})
	update()

var requests := Array()

func _draw():
	var req = requests.pop_front()
	if req:
		draw_polyline(req.points, req.color, req.width)
	
func is_mouse_over_editor():
	return get_global_mouse_position().x >= CurveEditor.rect_global_position.x
