extends Node2D
class_name BezCurve

var endpoints: Array
var anchors: Array

onready var CurveEditor = get_parent().get_parent().get_node('CurveEditor')

func edit():
	CurveEditor.open()
	CurveEditor.set_curve(self)
