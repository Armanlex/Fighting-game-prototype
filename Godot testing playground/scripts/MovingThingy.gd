extends Area2D



func _process(delta):
	get_parent().offset += 1



func _on_MovingThingy_body_entered(body):
	print(body," detected")
	pass # Replace with function body.
