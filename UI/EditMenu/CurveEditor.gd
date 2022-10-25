extends Control

var PackedCPE = preload("res://UI/EditMenu/ControlPointEditor.tscn")

func _ready():
	$NewCPEButton.connect('pressed', self, '_on_new_CPEButton_pressed')
	$DeleteButton.connect('pressed', self, '_on_DeleteButton_pressed')

var current_curve
signal editor_closed
var CPEs: Array

func set_curve(curve):
	current_curve = curve
	update()

func update():
	if len(CPEs) < len(current_curve.endpoints) + len(current_curve.anchors):
		if len(CPEs) == 0 and len(CPEs) < 4:
			for cpoint in current_curve.endpoints:
				create_CPE(cpoint)
			for cpoint in current_curve.anchors:
				create_CPE(cpoint)
	current_curve.update_curve2d()

func create_CPE(cpoint: ControlPoint) -> ControlPointEditor:
	var newCPE = PackedCPE.instance()
	newCPE.is_endpoint = cpoint.is_endpoint
	newCPE.point_position = cpoint.position
	newCPE.point = cpoint
	newCPE.label_text = cpoint.label()
	CPEs.push_back(newCPE)
	add_child(newCPE)
	return newCPE
	
func _on_new_CPEButton_pressed():
	if !current_curve:
		return
	var newcpoint = current_curve.create_new_cpoint(Vector2(0, 0), false)
	create_CPE(newcpoint)

func _on_DeleteButton_pressed():
	if !current_curve:
		return
	current_curve.queue_free()
	close()

var is_open := false

func open():
	is_open = true

func close():
	is_open = false
	current_curve = null
	for n in CPEs:
		n.queue_free()
	CPEs = []
	emit_signal("editor_closed")
