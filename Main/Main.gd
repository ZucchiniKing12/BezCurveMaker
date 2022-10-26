extends Node2D

func _ready():
	CurveEditor.set_position(Vector2(0, 0))
	CurveEditor.get_node('HidePointsButton').connect('pressed', self, '_on_hide_points_pressed')
	
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
	return get_global_mouse_position().x <= CurveEditor.rect_size.x

var render_configs: Dictionary

func register(curve: BezCurve):
	render_configs[curve.render_config.name] = curve.render_config
	curve.render_config.connect('render_config_changed', self, '_on_render_config_changed')
	connect('hide_points', curve, '_on_hide_points')

signal hide_points

func _on_hide_points_pressed():
	emit_signal('hide_points', CurveEditor.get_node('HidePointsButton').pressed)

func _on_render_config_changed():
	update()
		
func _draw():
	for c in render_configs:
		var config = render_configs[c]
		if config.active:
			var color = config.color
			if config.render_type == config.RENDER_TYPES.HOVER:
				color += Color(0.5, 0.5, 0.5, 1)
			color = clamp_color(color)
			draw_polyline(config.points, color, config.width)

func clamp_color(color: Color):
	return Color(min(color.r, 1), min(color.g, 1), min(color.b, 1), min(color.a, 1))
