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

func create_new_curve(pos: Vector2):
	var newcurve = PackedBezcurve.instance()
	newcurve.initialize(pos)
	$Curves.add_child(newcurve)
	register(newcurve)

func is_mouse_over_editor():
	return get_global_mouse_position().x <= CurveEditor.rect_size.x

var render_configs: Dictionary

func register(curve: BezCurve):
	render_configs[curve.render_config.name] = curve.render_config
	curve.render_config.connect('render_config_changed', self, '_on_render_config_changed')
	curve.render_config.connect('deactivate', self, '_on_render_config_deactivate')
	connect('hide_points', curve, '_on_hide_points')

func _on_render_config_deactivate(name):
	render_configs.erase(name)

signal hide_points

func _on_hide_points_pressed():
	emit_signal('hide_points', CurveEditor.get_node('HidePointsButton').pressed)

func _on_render_config_changed():
	update()
		
enum RENDER_TYPES {IDLE, HOVER, POINTS_HIDE}

func _draw():
	for c in render_configs:
		var config = render_configs[c]
		if config.active:
			# we get an error if we pass less than 2 points to draw_polyline,
			# hence we control for that (bc errors are Bad)
			var points = config.points
			if len(points) == 0:
				continue
			if len(points) <= 2:
				points.push_back(Vector2(points[len(points) - 1].x, points[len(points) - 1].y))
				
			var color = config.color
			if config.render_type == config.RENDER_TYPES.HOVER:
				color = lighten(color)
			color = clamp_color(color)
			
			draw_polyline(points, color, config.width)
			for cpoint in config.cpoints:
				draw_point(cpoint.position, config.curve_editing, color, config.width, config.render_type)

func draw_point(position: Vector2, is_editing: bool, color: Color, base_rad: float, render_type: int):
	print(render_type)
	if render_type == RENDER_TYPES.POINTS_HIDE:
		return
	var rad = base_rad * 1.5 if is_editing else base_rad * 0.5
	draw_circle(position, rad, color)
	if is_editing:
		draw_circle(position, rad * 0.5, lighten(color))
	

func lighten(color: Color):
	var r = min(1, 0.5 * color.r + 0.5)
	var g = min(1, 0.5 * color.g + 0.5)
	var b = min(1, 0.5 * color.b + 0.5)
	var a = 1
	return Color(r, g, b, a)
	
# clamps the color channels of a color to between 0 and 1 
func clamp_color(color: Color):
	return Color(max(min(color.r, 1), 0), max(min(color.g, 1), 0), max(min(color.b, 1), 0), max(min(color.a, 1), 0))
