extends Node2D

func _ready():
	add_child(CurveEditor)
	create_new_curve(Vector2(100, 100))
	
var PackedBezcurve = preload("res://BezCurve/BezCurve.tscn")

func create_new_curve(pos: Vector2) -> BezCurve:
	var newcurve = PackedBezcurve.instance()
	newcurve.initialize(pos)
	$Curves.add_child(newcurve)
	return newcurve
