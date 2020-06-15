extends Particles2D


func _process(delta):
	global_position = get_parent().get_node("Dog/Sprite3").global_position
