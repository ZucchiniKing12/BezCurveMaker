extends Node2D
class_name BezCurve

var endpoints: Array
var anchors: Array

var PackedCPoint = preload("res://BezCurve/ControlPoint.tscn")

func _ready():
	$EditMe.connect('pressed', self, 'edit')
	
func initialize(pos: Vector2):
	var end1 = create_new_cpoint(pos, true)
	var end2 = create_new_cpoint(pos + Vector2(50, -50), true)
	
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
	return newCP

func edit():
	CurveEditor.open()
	CurveEditor.set_curve(self)
