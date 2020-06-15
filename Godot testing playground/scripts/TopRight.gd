extends Node2D

#var CLICK_HERE = 2









func _ready():
	pass





func _process(delta):
	if global_position == get_parent().get_node("BottomLeft").global_position:
		global_position = get_parent().get_node("BottomLeft").global_position - Vector2(-100,100)

	
	
	
	

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event.get_button_mask() == 1:
		global_position = event.position
		
