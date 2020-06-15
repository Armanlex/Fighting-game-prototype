extends AnimatedSprite





var the_color = "dunno"


var value_a = 1


func _process(delta):
	
		
	
	
	self_modulate = Color(1,1,1,value_a)
	#print(frame, "--", playing, "--", speed_scale, "--", value_a)
	
	match animation:
		"jab_yellow","kick","punch": $StandLight.color = Color(0.8,1,0.1,1)
		"kick_red": $StandLight.color = Color(1,0.3,0,1)
		"punch_blue": $StandLight.color = Color(0,0.3,1,1)
		_: $StandLight.color = Color(0,0,0,0)
		
	$StandLight.value_a = value_a
		
	
	
	
	
	
	
func set_value(value_x):
	get_node("../Tween").stop_all()
	if value_x == 1:
		Global.emit_signal("humm")
		Global.emit_signal("appear")
		
	value_a = value_x


	


func _on_Stand_frame_changed():
	pass
	#var max_frames = frames.get_frame_count(animation)




func _on_Stand_animation_finished():
	playing = false
	#print("FINISHED!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	pass # Replace with function body.
