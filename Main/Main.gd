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
	register(newcurve)
	return newcurve

func is_mouse_over_editor():
	return get_global_mouse_position().x >= CurveEditor.rect_global_position.x

var render_configs: Array

func register(curve: BezCurve):
	render_configs.push_back(curve.render_config)
	curve.render_config.connect('render_config_changed', self, '_on_render_config_changed')

func _on_render_config_changed():
	print('update')
	update()
		
func _draw():
	for config in render_configs:
		var points = config.points
		draw_polyline(points, config.color, config.width)
