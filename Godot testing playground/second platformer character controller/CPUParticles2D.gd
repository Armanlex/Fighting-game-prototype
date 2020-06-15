extends CPUParticles2D








	


func change_emit(boolly, color_):
	emitting = boolly
	if boolly:
		Global.emit_signal("flame_stop")
		Global.emit_signal("flame")
		$DioLight.value_a = 1
		$DioLight.color = color_
	else:
		$DioLight.value_a = 0
		Global.emit_signal("flame_stop")
	
		
	if color_ != null:
		color = color_
