extends Control

var PackedCPE = preload("res://UI/EditMenu/ControlPointEditor.tscn")

func _ready():
	$NewCPEButton.connect('pressed', self, '_on_new_CPEButton_pressed')
	$DeleteButton.connect('pressed', self, '_on_DeleteButton_pressed')
	$ColorPicker/HBox/Button.connect('pressed', self, '_on_ColorPickerButton_pressed')
	$WidthSet/TextEdit.connect("text_changed", self, "_on_WidthChanged")

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
	if len(CPEs) >= 4:
		return
	if !current_curve:
		return
	var newcpoint = current_curve.create_new_cpoint(Vector2(260, 20), false)
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

var color_picker_open: bool
onready var color_picker := ColorPicker.new()

func _on_ColorPickerButton_pressed():
	if !is_open: 
		return
	if !color_picker.is_connected("color_changed", self, "_on_color_changed"):
		color_picker.connect("color_changed", self, "_on_color_changed")
	if color_picker_open:
		$ColorPicker.remove_child(color_picker)
		$ColorPicker/HBox/Button.text = 'Choose color'
	else:
		$ColorPicker.add_child(color_picker)
		$ColorPicker/HBox/Button.text = 'Done'
	color_picker_open = !color_picker_open

func _on_color_changed(new_color):
	$ColorPicker/HBox/ColorRect.color = new_color
	current_curve.color = new_color

func _on_WidthChanged():
	current_curve.width = float($WidthSet/TextEdit.text)
