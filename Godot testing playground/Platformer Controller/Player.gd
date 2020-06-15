extends KinematicBody2D




var actual_velocity = Vector2.ZERO
var desired_velocity = Vector2.ZERO

var side_speed = 400


var max_accel1 = 450
var max_accel2 = 150

var max_side_speed = 600
var max_fall_speed = 1300

var jump_power = 800
var gravity = 30

var wall_jump_power = 800
var wall_push_power = 600

var friction = 0.01
var duck_friction = 0.1
var drag = 0.01


var dash_power = 4000


var post_wall_jump_input_delay = 5
var post_wall_jump_input_delay_counter = 0

var charge_time_counter = 0
var charge_time_counter2 = 45



#var MainStates = ["grounded", "airborne"]
var MainState = "grounded"
var MainStateOld = "grounded"

#var GroundStates = ["idle", "standing", "ducking", "charging", "attacking", "moving", "dashing", "hit_stunned", "block_stunned", "knocked_down", "fallen"]
var GroundState = "idle"
var GroundStateOld = "idle"

#var AirStates = ["idle", "juggled", "attacking", "on_wall"]
var AirState = "idle"
var AirStateOld = "idle"








func state_logic(delta):
	
	
	
	match MainState:
		"grounded":
			match GroundState:
				"idle":
					$Sprite.animation = "idle"
					
					
					movement_inputs()
					attack_inputs()
					physics_simulation()
					visual_engine()
					
					
					
				"standing":
					movement_inputs()
					attack_inputs()
					physics_simulation()
					visual_engine()
					
					
				
				"ducking":

					
					movement_inputs()
					attack_inputs()
					
					physics_simulation()
					visual_engine()
					
				
				"charging":
					charge_time_counter += 1
					charge_time_counter2 += 1
					if charge_time_counter % 90 == 0:
						$CPUParticles2D.amount = 150 + charge_time_counter*2
						
					if charge_time_counter2 % 90 ==0:
						$CPUParticles2D3.amount = 150 + charge_time_counter*2
						
						
					$CPUParticles2D.lifetime = 0.7 + 0.04*(charge_time_counter/60.0)
					$CPUParticles2D3.lifetime = 0.7 + 0.04*(charge_time_counter/60.0)
					
					$CPUParticles2D.initial_velocity = 90 + 2*(charge_time_counter/60.0)
					$CPUParticles2D3.initial_velocity = 90 + 2*(charge_time_counter/60.0)
					print(charge_time_counter)
					attack_inputs()
					physics_simulation()
					
				
				"attacking":
					if $Sprite.animation == "punch":
						actual_velocity.x = 0
					desired_velocity.x = 0
					physics_simulation()
					visual_engine()
					
				"moving":
					$Sprite.animation = "run"	
						
					movement_inputs()
					attack_inputs()
					
					physics_simulation()
					visual_engine()
					
				"dashing":
					
					physics_simulation()
					visual_engine()
					
					
				"hit_stunned":
					
					physics_simulation()
					visual_engine()
					
				
				
				"block_stunned":
					
					physics_simulation()
					visual_engine()
				
				
				"knocked_down":
					
					physics_simulation()
					visual_engine()
					
				"fallen":
					pass
				
		"airborne":
			match AirState:
				"idle":
					
					
					if actual_velocity.y > 0:
						$Sprite.animation = "air_idle_down"
					elif actual_velocity.y < 0:
						$Sprite.animation = "air_idle_up"
					
						
					movement_inputs()
					attack_inputs()
					
					wall_check()
					landing_check()
					physics_simulation()
					visual_engine()
			
				"juggled":
					
					
					landing_check()
					physics_simulation()
					visual_engine()
					
				"attacking":
					
					
					
					landing_check()
					physics_simulation()
					visual_engine()
					
				"on_wall":
					
					wall_check()
					wall_physics()
					wall_inputs()
					movement_inputs()
					landing_check()
	
	







func get_transition(delta):
	return null # must return an array [main_state, secondary_state]
	
	
	
	
	
	

func enter_main_state(new_state, old_state): #this gets called when a state is entered
	match new_state:
		"":pass
		"":pass
		"":pass
			
	match old_state:
		"":pass
		"":pass
		"":pass
			
			
func enter_secondary_state(new_state, old_state): #this gets called when a state is entered
	
	match new_state:
		"ducking": 
			if old_state != "ducking":
				$Sprite.animation = "duck_descend" 
				print("DESCEND!", old_state)
			
			
		"idle":
			match old_state:
				"attacking":pass
				"ducking":$Sprite.play("duck_ascend")
				
				
				
		"on_wall":
			$Sprite.play("wall_grab")
			desired_velocity.y = 0
			actual_velocity.y = 0
			
		"charging":
			$Sprite.animation = "charge"
			$CPUParticles2D.emitting = true
			$CPUParticles2D2.emitting = true
			$CPUParticles2D3.emitting = true
			
	match old_state:
		"":pass
		"":pass
		"":pass
	






func exist_main_state(new_state, old_state): #this gets called when a state is being abandoned
	
	match new_state:
		"":pass
		"":pass
		"":pass
			
	match old_state:
		"":pass
		"":pass
		"":pass

func exist_secondary_state(new_state, old_state): #this gets called when a state is being abandoned
	
	match new_state:
		"ducking":
			pass
			
		"":pass
		"":pass
			
	match old_state:
		"":pass
		"":pass
		"":pass
	






func set_state(new_main_state, new_sec_state): #call this state to change state
	print("attempt to set state: ",new_main_state, " and ",new_sec_state)
	MainStateOld = MainState
	GroundStateOld = GroundState
	AirStateOld = AirState
	
	MainState = new_main_state
	
	match new_main_state:
		"grounded":
			GroundState = new_sec_state
			if GroundStateOld != null:
				exist_secondary_state(new_sec_state, GroundStateOld)
			if new_sec_state != null:
				enter_secondary_state(new_sec_state, GroundStateOld)
				
		"airborne":
			AirState = new_sec_state
			if AirStateOld != null:
				exist_secondary_state(new_sec_state, AirStateOld)
			if new_sec_state != null:
				enter_secondary_state(new_sec_state, AirStateOld)
	
	if MainStateOld != null:
		exist_main_state(new_main_state, MainStateOld)
	
	if new_main_state != null:
		enter_main_state(new_main_state, MainStateOld)
		

	
	
	
			

	


func _physics_process(delta):
	$Label.text = str(MainState," - ",GroundState, "/",AirState)
	timers()
	#readout() #types a bunch of bullshit on the console
	
	
	state_logic(delta)
	
	var transition = get_transition(delta)
	if transition != null:
		set_state(transition[0], transition[1])
		

	
	









	
	


func physics_simulation():
	
	actual_velocity.y += desired_velocity.y
	desired_velocity.y = 0
	actual_velocity.y += gravity	
	
	actual_velocity.x = (actual_velocity.x*3.0 + desired_velocity.x)/4.0
	

	
	match MainState:
		"grounded": 
			if not (Input.is_action_pressed("camera_left") or Input.is_action_pressed("camera_right")):
				var total_friction = (friction + ((friction/100) * abs(actual_velocity.x)))
				if total_friction < 0.01 and total_friction > -0.01:
					total_friction = 0
					
				actual_velocity.x = actual_velocity.x / (1 + total_friction)
				print("total friction: ",total_friction)
			if not GroundState == "dashing":
				if actual_velocity.x > max_side_speed:
					actual_velocity.x = max_side_speed
				elif actual_velocity.x < -max_side_speed:
					actual_velocity.x = -max_side_speed
					
			
		"airborne":
			var total_friction = (drag + ((drag/100) * abs(actual_velocity.x)))
			
			if total_friction < 0.01 and total_friction > -0.01:
				total_friction = 0
			
			actual_velocity.x = actual_velocity.x / (1 + total_friction)
			print("total friction: ",total_friction)
			
	if abs(actual_velocity.x) < 1:
		actual_velocity.x = 0
	
	if actual_velocity.y > max_fall_speed:
		actual_velocity.y = max_fall_speed
		
	actual_velocity = move_and_slide(actual_velocity, Vector2(0,-1))	
	
	
	
	if is_on_floor() == false and MainState == "grounded":
		set_state("airborne", "idle")		
		
			
	
		
	











func attack_inputs():
	if Input.is_action_just_pressed("ui_up"): #ATTACK BUTTON
		match MainState:
			"grounded":
				if GroundState == "ducking":
					set_state("grounded", "attacking")
					$Sprite.play("duck_attack")
				
				else:
					set_state("grounded", "attacking")
					$Sprite.play("punch")
					
				
				
			"airborne":
				set_state("airborne", "attacking")
				$Sprite.play("air_kick")
				
	if Input.is_action_just_pressed("ui_down"):
		match MainState:
			"grounded":
				if GroundState == "moving":
					if $Sprite.flip_h:
						actual_velocity.x -= dash_power
					else:
						actual_velocity.x += dash_power
					set_state("grounded", "dashing")
					$Sprite.play("dash")
					
				if GroundState == "ducking":
					set_state("grounded", "charging")
					
				
				
			"airborne":pass
			
	if Input.is_action_just_released("ui_down"):
		match MainState:
			"grounded":
				if GroundState == "charging":
					set_state("grounded", "attacking")
					$Sprite.play("super")
					$CPUParticles2D.emitting = false
					$CPUParticles2D2.emitting = false
					$CPUParticles2D3.emitting = false
					charge_time_counter2 = 45
					charge_time_counter = 0
					
					$CPUParticles2D.amount = 150
					$CPUParticles2D3.amount = 150
					$CPUParticles2D.lifetime = 0.7
					$CPUParticles2D3.lifetime = 0.7
					$CPUParticles2D.initial_velocity = 90
					$CPUParticles2D3.initial_velocity = 90


		
		
		
		

func movement_inputs():
	match MainState:
		"grounded":
			desired_velocity.x = 0
			
			if GroundState != "ducking":
				if Input.is_action_pressed("camera_left"):
					desired_velocity.x -= 1
					
				if Input.is_action_pressed("camera_right"):
					desired_velocity.x += 1
					
				if desired_velocity.x == 1 or desired_velocity.x == -1:
					desired_velocity.x = desired_velocity.x * side_speed
					
			if not Input.is_action_pressed("camera_down"):
				if (desired_velocity.x > 0 or desired_velocity.x < 0):
					set_state("grounded", "moving")
				else:
					set_state("grounded", "idle")
		
				
				
			if Input.is_action_pressed("camera_down"):
				set_state("grounded", "ducking")
			
			
			if Input.is_action_just_pressed("tween"):
				desired_velocity.y = -jump_power
				set_state("airborne", "idle")
				
				
			if not Input.is_action_pressed("camera_down") and GroundState == "ducking":
				set_state("grounded", "idle")
				
				
		"airborne":
			
			desired_velocity.x = 0
			if Input.is_action_pressed("camera_left") or Input.is_action_pressed("camera_right"):
				if post_wall_jump_input_delay_counter == post_wall_jump_input_delay:
					if Input.is_action_pressed("camera_left"):
						desired_velocity.x -= 1
						
					if Input.is_action_pressed("camera_right"):
						desired_velocity.x += 1
						
					if desired_velocity.x == 1 or desired_velocity.x == -1:
						desired_velocity.x = desired_velocity.x * side_speed
			else:
				desired_velocity.x = actual_velocity.x
				
			if Input.is_action_pressed("camera_down"):
				desired_velocity.y += 20
				
				
	
	
	
	


func landing_check():
	if MainState == "airborne":
		if is_on_floor():
			match AirState:
				"idle":
					set_state("grounded", "idle")
				"juggle":
					set_state("grounded", "fallen")
				"attacking":
					set_state("grounded", "idle")
					





func visual_engine():
	
	if actual_velocity.x > 0:
		$Sprite.flip_h = false
	elif actual_velocity.x < 0:
		$Sprite.flip_h = true



	
		
		

	
func timers():
	if not post_wall_jump_input_delay_counter == post_wall_jump_input_delay:
		post_wall_jump_input_delay_counter += 1




func attacked(what):
	match what:
		"punch":pass
		"kick":pass



func wall_physics():
	
	
	pass

func wall_inputs():
	if Input.is_action_just_pressed("tween"):
		actual_velocity.y = -wall_jump_power
		if $Sprite.flip_h == true:
			actual_velocity.x = wall_push_power
		else:
			actual_velocity.x = -wall_push_power
		set_state("airborne", "idle")
		post_wall_jump_input_delay_counter = 0
		


func wall_check():
	
	var ray_left1 = false
	var ray_left2 = false
	var ray_right1 = false
	var ray_right2 = false
		
	if $RayCast2DLeft.get_collider() != null:
		if $RayCast2DLeft.get_collider().is_in_group("wall"):
			ray_left1 = true
			
	if $RayCast2DLeft2.get_collider() != null:
		if $RayCast2DLeft2.get_collider().is_in_group("wall"):
			ray_left2 = true
			
	if $RayCast2DRight.get_collider() != null:
		if $RayCast2DRight.get_collider().is_in_group("wall"):
			ray_right1 = true
			
	if $RayCast2DRight2.get_collider() != null:
		if $RayCast2DRight2.get_collider().is_in_group("wall"):
			ray_right2 = true
			
			


	if MainState == "airborne" and AirState != "on_wall":
		if Input.is_action_pressed("camera_left"):
			if ray_left1 and ray_left2 and actual_velocity.y > -70:
				$Sprite.flip_h = true
				set_state("airborne", "on_wall")

	
		if Input.is_action_pressed("camera_right"):
			if ray_right1 and ray_right2 and actual_velocity.y > -70:
					$Sprite.flip_h = false
					set_state("airborne", "on_wall")
				
	elif MainState == "airborne" and AirState == "on_wall":
		if not(ray_left1 or ray_left2 or ray_right1 or ray_right2):
			set_state("airborne", "idle")
			
		if (not Input.is_action_pressed("camera_left")) and (not Input.is_action_pressed("camera_right")):
			set_state("airborne", "idle")
	

		if ray_left1 and ray_left2:
			if not Input.is_action_pressed("camera_left"):
				set_state("airborne", "idle")
				
		elif ray_right1 and ray_right2:
			if not Input.is_action_pressed("camera_right"):
				set_state("airborne", "idle")
		




func receive_attack(type, height, hit_frames, hit_push, block_frames, block_push, dmg, launch_power):
#	if blocking:
#		blocked(block_frames, block_push)
#	else:
#		match type:
#			"normal":pass
#
#			"juggle":pass
#
#			"KND":pass
	pass
		
	
	
		
		
func blocked(block_frames, block_push):
	#do block stuff
	pass
	







func _on_Sprite_animation_finished():
	match $Sprite.animation:
		"punch":
			set_state("grounded", "idle")
			
		"air_kick":
			set_state("airborne", "idle")
		"duck_attack":
			set_state("grounded", "ducking")
		"duck_descend":
			$Sprite.animation = "duck_loop"
		"duck_ascend":
			$Sprite.animation = "idle"
		"dash":
			$Sprite.animation = "run"
			set_state("grounded", "moving")
		"super":
			set_state("grounded", "idle")
			





func readout():
	print("")
	print("main state: ", MainState)
	print("ground state: ", GroundState)
	print("air state: ", AirState)
	print("animation name: ",$Sprite.animation, " frame: ", $Sprite.frame)
	print("")
