extends Sprite

#var CLICK_HERE = 2








	
	

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event.get_button_mask() == 1:
		global_position = event.position
		


