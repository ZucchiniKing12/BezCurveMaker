extends Position2D
class_name ControlPoint

var is_endpoint = false
var endpoint_index = -1

var t1 = preload("res://BezCurve/point.png")
var t2 = preload("res://BezCurve/small_point.png")

func _ready():
	pass#$Button.connect("button_down", self, 'on_button_down')

func _process(delta):
	var mouse_coords = get_global_mouse_position()	
	
	$Sprite.texture = t1 if is_endpoint else t2
	
	if dist(mouse_coords, position) < $Sprite.texture.get_width() * 0.5:
		$Sprite.scale = Vector2(2, 2)
	else:
		$Sprite.scale = Vector2(1, 1)


func dist(a, b):
	return sqrt((b.x - a.x) * (b.x - a.x) + (b.y - a.y) * (b.y - a.y))

func on_button_down():
	pass

var editing := false
