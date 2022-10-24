extends Sprite

var time = 0

func _process(delta):
	time += 1
	if time > 120:
		queue_free()
