extends VBoxContainer
class_name ControlPointEditor

onready var CURVE_EDITOR = get_tree().get_root().get_node('Main').get_curve_editor()

var is_endpoint: bool = false
var point_name: String
var point: ControlPoint setget set_point, get_point
func set_point(p: ControlPoint):
	point = p
	point.connect("position_moved", self, '_on_position_moved')
func get_point():
	return point
func _on_position_moved(_name, _new_pos):
	$Position/X.text = str(_new_pos.x)
	$Position/Y.text = str(_new_pos.y)

func _draw():
	if is_endpoint:
		$Manage/DeleteButton.disabled = true
	if CURVE_EDITOR.at_max_points():
		$Manage/DuplicateButton.disabled = true
	else:
		$Manage/DuplicateButton.disabled = false
		
var point_position := Vector2() setget set_point_position, get_point_position
func set_point_position(pos):
	point_position = pos
	$Position/X.text = str(pos.x)
	$Position/Y.text = str(pos.y)
func get_point_position():
	return point_position
	
var label_text = 'Point' setget set_label, get_label
func set_label(text):
	$Label.text = text
func get_label():
	return $Label.text
	
func _ready():
	$Position/X.connect("text_changed", self, '_text_changed')
	$Position/Y.connect("text_changed", self, '_text_changed')
	$Manage/DuplicateButton.connect('pressed', self, '_on_duplicateButton_pressed')
	$Manage/DeleteButton.connect('pressed', self, '_on_deleteButton_pressed')

signal duplicate_point_pressed

func _on_duplicateButton_pressed():
	emit_signal('duplicate_point_pressed', point.position)

func _text_changed():
	point_position = Vector2( float($Position/X.text), float($Position/Y.text) )
	point.position = point_position
	CURVE_EDITOR.update()

signal delete_point_pressed

func _on_deleteButton_pressed():
	if is_endpoint:
		return
	emit_signal('delete_point_pressed', self)
