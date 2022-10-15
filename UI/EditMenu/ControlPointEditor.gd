extends VBoxContainer

var is_endpoint: bool = false

var value := Vector2() setget set_value, get_value
func set_value(val):
	value = val
	$Values/X.text = str(val.x)
	$Values/Y.text = str(val.y)
func get_value():
	return value
	
var label_text = 'Point' setget set_label, get_label
func set_label(text):
	$Label.text = text
func get_label():
	return $Label.text
	
func _ready():
	$Values/X.connect("text_changed", self, '_text_changed')
	$Values/Y.connect("text_changed", self, '_text_changed')

func _text_changed():
	value = Vector2( float($Values/X.text), float($Values/Y.text) )
