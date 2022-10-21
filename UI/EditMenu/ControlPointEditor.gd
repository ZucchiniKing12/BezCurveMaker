extends VBoxContainer
class_name ControlPointEditor

var is_endpoint: bool = false
var point_name: String
var point: ControlPoint

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

func _text_changed():
	point_position = Vector2( float($Position/X.text), float($Position/Y.text) )
	point.position = point_position
