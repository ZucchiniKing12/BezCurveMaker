extends Node2D

func _ready():
	# add the editor as a child so we can see it in the viewport
	add_child(CurveEditor)
	CurveEditor.set_position(Vector2(get_viewport().size.x - 300, 0))
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.doubleclick:
			CurveEditor.close()
			create_new_curve(event.position)

var PackedBezcurve = preload("res://BezCurve/BezCurve.tscn")

func create_new_curve(pos: Vector2) -> BezCurve:
	var newcurve = PackedBezcurve.instance()
	newcurve.initialize(pos)
	$Curves.add_child(newcurve)
	newcurve.connect('request_render', self, '_on_request_render')
	return newcurve

var debugSprite = preload("res://debugSprite.tscn")

func _on_request_render(reason: String, curve: BezCurve):
	for point in curve.curve.get_baked_points():
		var t = debugSprite.instance()
		add_child(t)
		t.position = point
	requests.push_back(
		{ 
			'points': curve.curve.get_baked_points(), 
			'color': curve.render_config.color,
			'width': curve.render_config.width
		})
	update()

var requests := Array()

func _draw():
	var req = requests.pop_front()
	if req:
		draw_polyline(req.points, req.color, req.width)
	
