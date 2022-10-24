extends Node
class_name RenderConfig

var color: Color setget set_color
func set_color(c: Color):
	request_change('color', c, color)
	color = c
	
var width: float setget set_width
func set_width(w):
	request_change('width', w, width)
	width = w

var requests := Array()

func request_change(type, new, old):
	requests.push_back(
		{
			'type': type,
			'new': new,
			'old': old
		})

func _process(delta):
	var req = requests.pop_front()
	change_render_config(req)
	
func change_render_config(change):
	emit_signal("render_config_changed", { 'type': change.type, 'new': change.new, 'old': change.old})
