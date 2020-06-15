extends KinematicBody2D

#var CLICK_HERE = 2


var direction = Vector2(0,0)
var x = 0
var y = 0


signal new_rotation(vector)






func _ready():
	pass





func _physics_process(delta):
	dog_spin()
	
	
	
	




func dog_spin():
	
	if rotation_degrees >= 360:
		rotation_degrees -= 360
	elif rotation_degrees <= -360:
		rotation_degrees += 360
	
	x += 1
	if x % 120 == 0:
		x = 1
		
		
		
		direction = Vector2((randi()%21)-10,(randi()%21)-10)/2 #generate a random direction, this exists for testing purposes only
		while direction == Vector2.ZERO:
			direction = Vector2((randi()%21)-10,(randi()%21)-10)/2
		direction = direction.normalized()
		direction = direction * 8 #I multiply it so my test unit moves more noticably, this is for testing too
		
	
		
		
		
		
		
		
		
		var difference = rad2deg(direction.angle()) - rotation_degrees #calculate the difference in angle between current rotation and desired direction
				
		if difference > 181: 
			difference = -360 + difference
		elif difference < -181: 
			difference = 360 + difference
		
		get_parent().get_node("Tween").stop(self, "rotation_degrees")
		get_parent().get_node("Tween").interpolate_property(get_node("."), "rotation_degrees", rotation_degrees, rotation_degrees+difference, (0.003*abs(difference))+0.1,Tween.TRANS_SINE,Tween.EASE_IN_OUT,0.1)
		get_parent().get_node("Tween").start()
		
		
		
		
		
		
		
		
		
		if difference > 180 or difference < -180:
			print("ALARMMMMM ALARMMMMMMMMMMMM")
			print("ALARMMMMM ALARMMMMMMMMMMMM")
			print("ALARMMMMM ALARMMMMMMMMMMMM")
			print("ALARMMMMM ALARMMMMMMMMMMMM")
			print("ALARMMMMM ALARMMMMMMMMMMMM")
			print("difference: ",difference, " rotation_degrees: ", rotation_degrees, " direction: ",direction)
			print(" ")
			
		
	
		emit_signal("new_rotation",direction*30+global_position)
		
		
		var smol_dog = get_parent().get_node("smoldog")
		
		get_parent().get_node("Tween2").interpolate_property(smol_dog, "global_position", smol_dog.global_position, direction*30+global_position, 0.3,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
		get_parent().get_node("Tween2").start()

	
func _on_Tween_tween_completed(object, key):
	pass # Replace with function body.
