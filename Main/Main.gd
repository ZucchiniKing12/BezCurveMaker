extends Node2D

func _ready():
	add_child(CurveEditor)

func _input(event):
	if event is InputEventMouseButton:
		if event.doubleclick:
			create_new_curve()
		if not event.pressed and not event.doubleclick and event.button_index == 2:
			var curve = check_for_curves()[0]
			if curve:
				curve.edit()

var packed_curve = preload("res://BezCurve/BezCurve.gd")
var active_curves = []
onready var container = get_node('CurveContainer')
			
func create_new_curve():
	var new_curve = packed_curve.instance()
	container.add_child(new_curve)
	active_curves.push_back(new_curve)
	new_curve.edit()
	return new_curve

func check_for_curves():
	 return []
