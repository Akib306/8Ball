extends ParallaxBackground

var scroll_speed = Vector2(8, 0)  

func _process(delta):
	# Move the background automatically by adjusting the scroll_offset
	scroll_offset += scroll_speed * delta
