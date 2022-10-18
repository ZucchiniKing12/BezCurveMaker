extends Control

var PackedCPE = preload("res://UI/EditMenu/ControlPointEditor.tscn")

func _ready():
	#$NewCPEButton.connect('pressed', self, '_create_new_point')
	visible = is_open

var current_curve

var endpoint_editors: Array
var anchor_editors: Array

func set_curve(curve):
	current_curve = curve
	rect_global_position = curve.position
	for endpoint in curve.endpoints:
		load_point_into_editor(endpoint)
	for anchor in curve.anchors:
		load_point_into_editor(anchor)

func _create_new_point():
	pass

func load_point_into_editor(cpoint: ControlPoint):
	var newCPE = PackedCPE.instance()
	newCPE.is_endpoint = cpoint.is_endpoint
	if newCPE.is_endpoint:
		newCPE.label_text = 'Endpoint ' + str(cpoint.endpoint_index)
	newCPE.value = cpoint.position
	if newCPE.is_endpoint:
		endpoint_editors.push_back(newCPE)
	else:
		print(newCPE)
		anchor_editors.push_back(newCPE)
	add_child(newCPE)
	
func update_curve():
	for n in [0,1]:
		current_curve.endpoints[n].position = endpoint_editors[n].value
	for n in range(len(anchor_editors)):
		current_curve.anchors[n].position = anchor_editors[n].value

var is_open := false

func open():
	is_open = true
	visible = true
