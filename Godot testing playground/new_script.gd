extends Node










#
#
## standing, moving, dashing, crouching, block_stun, hit_stun, attacking, parry_red, parry_blue # this is a list of states I've implemented to my player character atm
#
#var State = "standing"
#var State_old = "standing"
#
#
#
#func set_state(new_state, who_did_the_change): #this is where the magic happens. Only chage states through this function, so it's much much easier to manage multiple states
#	print("state changed by: ", who_did_the_change," into: ", new_state) #it's important that when you call a state change you also give a tag as the second argument so you more easily know wtf happened when something goes wrong. I used to get so confused trying to figure what where in the code a state changed that I wasn't expecting happened, and this tag trick is extremely helpful
#
#	State_old = State
#	State = new_state
#
#	match new_state: #code that I want to run when I enter a specific state, useful for animations and to reset values
#		"":pass
#		"":pass
#
#
#
#	match State_old: #code that I want to run when I exit a state, I don't use this often but it's still good to have.
#		"":pass
#		"":pass
#		"":pass	
#
#
#
#
#
#
#
#
#
#
#
#func _physics_process(delta):
#	#readout()
#
#
#	#Here are all the functions for all behaviors that I want to run in the loop. I check if they should run based on the allowed states at the start of those functions
#
#	attack_inputs()
#	general_physics_system(delta)
#	set_state_based_on_walking()
#	ground_animation_system()
#
#
#	match State: # code that I want to run every loop for specific states, mostly used for very small stuff
#		"standing":pass
#		"moving":pass
#		"dashing":pass
#		"crouching":pass
#		"block_stun":pass
#		"hit_stun":pass
#		"attacking":pass
#		"parry_blue":pass
#		"parry_red":pass
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#func attack_inputs(): #checks if an attack/parry button is pressed. As you can see I know check for attack inputs on specific states. I don't want the player to be able to attack this he's stunned or in the middle of another attack
#	#============================================================================================= < this is how I manage if when this function is allowed to run. This 
#	var allowed_states = ["standing", "moving", "crouching"]
#	if allowed_states.has(State):
#	#=============================================================================================
#
#		if Input.is_action_just_pressed("ui_right"):
#			$AnimatedSprite.play("parry_blue")
#			set_state("parry_blue", "right parry")
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#func general_physics_system(delta): #this is the basic physics/movement code. It's always active but dunno, maybe I later make a state where I want to disable it :P
#	#=============================================================================================
#	var allowed_states = ["standing", "moving", "dashing", "crouching", "block_stun", "hit_stun", "attacking", "parry_red", "parry_blue"]
#	if allowed_states.has(State):
#	#=============================================================================================
#
#		velocity_current.y += gravity
#
#		velocity_current.x = (velocity_current.x + walk_speed*2) / 3 #interpolates walk speed into current x velocity
#
#		velocity_current = move_and_slide(velocity_current*delta*60)
#
#
#
#
#
#
#
#
#
#
#func set_state_based_on_walking(): #this code manages the standing/moving STATES based on current velocity.x movement. 
#	#=============================================================================================
#	var allowed_states = ["standing", "moving"]
#	if allowed_states.has(State):
#	#=============================================================================================
#
#		if abs(velocity_current.x) > 0.2 and State != "moving":
#			set_state("moving", "bottom of general_physics_system")
#		elif velocity_current.x < 0.2 and velocity_current.x > -0.2 and State != "standing":
#			set_state("standing", "bottom of general_physics_system")
#
#
#
#
#
#
#
#
#
#
#func ground_animation_system(): #this code manages the walking/running/standing ANIMATIONS based on current velocity.x movement. 
#	#=============================================================================================
#	var allowed_states = ["standing", "moving"]
#	if allowed_states.has(State):
#	#=============================================================================================
#
#		#if State != "dashing" and State != "crouching": #maybe should remove this if nothing weird happens here
#		if velocity_current.x > 0.1:
#			if abs(velocity_current.x) > 102:
#				$AnimatedSprite.animation = "run"
#			elif abs(velocity_current.x) > 1:
#				$AnimatedSprite.animation = "walk"
#			elif abs(velocity_current.x) < 1:
#				$AnimatedSprite.animation = "standing"
#
#		elif velocity_current.x < -0.1:
#			if abs(velocity_current.x) > 102:
#				$AnimatedSprite.animation = "run_rev"
#			elif abs(velocity_current.x) > 1:
#				$AnimatedSprite.animation = "walk_rev"
#			elif abs(velocity_current.x) < 1:
#				$AnimatedSprite.animation = "standing"
#
#
#
#
#
#
#
#
#
#
#
#
#
#func _on_AnimatedSprite_animation_finished(): #this is how I return to standing state after an action has finished. When the attack animation is over I just set_state back to standing
#	match $AnimatedSprite.animation:
#		"back_dash":
#			set_state("standing", "back_dash / _on_AnimatedSprite_animation_finished")
#
#		"parry_blue":
#			$AnimatedSprite.play("parry_blue_fail")
#			set_state("attacking", "321")
#		_:
#			if State == "attacking":
#				set_state("standing", "if State == attacking:")
		
		
		
		
		
		
		
		
		
		
		











































	
	

	
	
	
	
	
	
















