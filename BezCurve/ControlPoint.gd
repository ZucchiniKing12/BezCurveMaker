extends Position2D
class_name ControlPoint

var is_endpoint = false
var endpoint_index = -1

var t1 = preload("res://BezCurve/point.png")
var t2 = preload("res://BezCurve/small_point.png")

func _process(delta):
	$Sprite.texture = t1 if is_endpoint else t2
