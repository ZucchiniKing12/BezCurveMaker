extends Control

var PackedCPE = preload("res://UI/EditMenu/ControlPointEditor.tscn")

func _ready():
	$NewCPEButton.connect('pressed', self, '_on_new_CPEButton_pressed')
	visible = is_open

var current_curve

var CPEs: Array

func set_curve(curve):
	current_curve = curve
	set_global_position(current_curve.position)
	update()

func update():
	if len(CPEs) < len(current_curve.endpoints) + len(current_curve.anchors):
		if len(CPEs) == 0:
			for cpoint in current_curve.endpoints:
				CPEs.push_back(create_CPE(cpoint))
			for cpoint in current_curve.anchors:
				CPEs.push_back(create_CPE(cpoint))

func create_CPE(cpoint: ControlPoint) -> ControlPointEditor:
	var newCPE = PackedCPE.instance()
	newCPE.is_endpoint = cpoint.is_endpoint
	newCPE.point_position = cpoint.position
	newCPE.point = cpoint
	newCPE.label_text = cpoint.label()
	add_child(newCPE)
	return newCPE
	
func _on_new_CPEButton_pressed():
	var newcpoint = current_curve.create_new_cpoint(Vector2(0, 0), false)
	create_CPE(newcpoint)

var is_open := false

func open():
	is_open = true
	visible = true

func close():
	is_open = false
	visible = false
