extends Node2D
class_name BezCurve

var endpoints: Array
var anchors: Array

var PackedCPoint = preload("res://BezCurve/ControlPoint.tscn")

func _ready():
	$EditMe.connect('pressed', self, 'edit')
	
	# temporarily load some bogus data to see if dis works
	var end1 = PackedCPoint.instance()
	var end2 = PackedCPoint.instance()
	var anc1 = PackedCPoint.instance()
	end1.position = Vector2(100, 100)
	end1.is_endpoint = true
	end1.endpoint_index = 1
	end2.position = Vector2(300, 0)
	end2.is_endpoint = true
	end2.endpoint_index = 2
	anc1.position = Vector2(200, 50)
	endpoints.push_back(end1)
	endpoints.push_back(end2)
	anchors.push_back(anc1)
	
	render()

func edit():
	CurveEditor.open()
	CurveEditor.set_curve(self)

func render():
	for cpoint in endpoints:
		$ControlPoints.add_child(cpoint)
	for cpoint in anchors:
		$ControlPoints.add_child(cpoint)
