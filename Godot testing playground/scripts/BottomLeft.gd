extends Node2D

#var CLICK_HERE = 2









func _ready():
   print("test")





func _process(delta):
	if global_position == get_parent().get_node("TopRight").global_position:
		global_position = get_parent().get_node("TopRight").global_position - Vector2(100,-100)
	pass
	
	
	
	
	

#print("CLICK_HERE: ", CLICK_HERE)
#get_tree().get_root().get_node("TopNode/SecondNode")

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event.get_button_mask() == 1:
		global_position = event.position
		
