extends KinematicBody2D




			
	


#notes:

# BKD: un-crouching while backdash is on cooldown will reduce the cooldown and you can just tap back once to back dash again, that makes is so you can link backdashes with a quick crouch cancel



#var state_list_full = ["standing", "ducking", "charging", "attacking", "hit_stunned", "block_stunned", "knocked_down",
					# "fallen", "walking", "running", "dashing", "airborne", "diving", "air_juggled", "air_attack", "wall_stuck", "wall_sliding]

#var state_list_grounded = ["standing", "ducking", "charging", "attacking", "hit_stunned", "block_stunned", "knocked_down", "fallen", "walking", "running", "dashing"]

#var state_list_has_control = ["standing", "ducking", "charging", "walking", "running", "airborne", "on_wall", "diving"]

#var state_list_stationary = ["standing", "ducking", "charging", "attacking", "hit_stunned", "block_stunned", "knocked_down", "fallen", "wall_stuck"]

#var state_list_counter_hit = ["charging", "attacking", "air_attack"]






# standing, moving, dashing, crouching, block_stun, hit_stun, attacking, parry_red, parry_blue

var State = "standing"
var State_old = "standing"






var gravity = 10
var velocity_current = Vector2.ZERO
var jump_power = 0




#--- RUNNING ----

var run_speed_max = 0
var run_acceleration = 0
var run_friction = 0

const RUN_SPEED_MAX = 250
const RUN_ACCELERATION = 25
const RUN_FRICTION = 0.7




#--- WALKING ----

var walk_speed_max = 100 #max vertical speed
var walk_speed = 0 #current desired vertical speed
var walk_acceleration = 30 #acceleration that increases the above speed

var walk_friction_mult = 0.5 #multiplied by current velocity.x
var walk_friction_static = 2 #constant friction
var walk_friction_formula = null





#--- DASHING ---

var dash_base_speed = 0
var dash_break_acceleration = 0

#back_dash
var backdash_speed = -950
var back_dash_anti_accel = 58
var second_input_back_dash_delay = -70
	
	



var health = 150
var max_health = 150







#func _input(event):
#	if Input.is_action_just_pressed("tween"):
#		attack_received(damage, ch_damage, is_high, color, block_stun, hit_stun, ch_stun, pushback)
#		#attack_received(0, 0, false,"red", 10, 15, 60, -50)
#		pass
		
		
		
func _ready():
	Global.connect("start_match",self,"start_match")




var begin = false
func start_match():
	begin = true


func set_state(new_state, who_did_the_change):
	
	#print("KILLUA: state changed by: ", who_did_the_change," into: ", new_state)
	
	State_old = State
	State = new_state

	match new_state:
		"standing":
			dash_base_speed = 0
			dash_break_acceleration = 0
			match State_old:
				"hit_stun":
					walk_speed = 0
					velocity_current.x = 0
					$AnimatedSprite.play("stun_hit_end")
				"block_stun":
					walk_speed = 0
					velocity_current.x = 0
					$AnimatedSprite.play("stun_block_end")
				_:
					$AnimatedSprite.animation = "standing"
					if State_old == "dashing":
						velocity_current.x = 0
				
		"crouching":
			$AnimatedSprite.play("crouch_start")
			ground_movement_state = "walk"
			
		"block_stun":
			$AnimatedSprite.play("stun_block_loop")
		
		"hit_stun":
			$AnimatedSprite.play("stun_hit_loop")
			
		"attacking":
			ground_movement_state = "walk"
			back_dash_state = "wait"
			walk_speed = 0
			velocity_current.x = 0
			
		"dead":
			Global.emit_signal("play_sound","2hurt4",1,5)
			$AnimatedSprite.play("dead")
			get_parent().get_node("BadPlayer").set_state("winner", "player said so")
			walk_speed = 0
			velocity_current.x = 0
		
		"winner":
			pass
		"parry_red":
			spawn_effect("red_pre_parry")
			Global.emit_signal("play_sound","2parry",1,-21)
			Global.emit_signal("large_light", global_position, Color(1,0.5,0.1,1), 2.5, 0.7, 0.1, 0.8) #(position, color, size, power, start_time, end_time)
		"parry_blue":
			spawn_effect("blue_pre_parry")
			Global.emit_signal("play_sound","2parry",1,-21)
			Global.emit_signal("large_light", global_position, Color(0,0.3,1,1), 2.5, 0.7, 0.1, 0.8) #(position, color, size, power, start_time, end_time)
	
		
		
	
	match State_old:
		"":pass
		"":pass
		"":pass	
	

	
	
	
	
	
	
	
	
	
func _physics_process(delta):
	#$State.text = State
	
	if controls_reversed:
		$State.rect_scale.x = -1
	else:
		$State.rect_scale.x = 1
	
	
	#readout()
	if begin:
		input_translator()
		
		stun_duration_system()
		
		attack_buffer_system()
		
		attack_inputs()
		
		crouch_check()
		
		ground_movement_state_input_system()
		
		ground_movement_system()
		
		general_physics_system(delta)
		
		set_state_based_on_walking()
		
		ground_animation_system()
		
		visual_update()
		
	
		match State:
			"standing":pass
			"moving":pass
			"dashing":pass
			"crouching":
				walk_speed = 0
			"block_stun":pass
			"hit_stun":pass
			"attacking":
				walk_speed = 0
			"parry_blue":
				walk_speed = 0
			"parry_red":
				walk_speed = 0



	
			
		
			
			
			
			
			
			
			
			
		
		
		
		
		

		
var quick_attack_buffer = false
var slow_attack_buffer = false

var attack_buffer_delay = 15 #for how many frames can you buffer an attack while in a non attacking state. So you don't have to press an attack frame perfectly to get the perfect punish, but instead do it sligtly before the blockstun ends
var attack_buffer_counter = 0

func attack_buffer_system():
	#=============================================================================================
	var allowed_states = ["standing", "moving", "crouching", "dashing", "block_stun", "attacking"]
	if allowed_states.has(State):
	#=============================================================================================
		
		if Input.is_action_just_pressed("ui_up"):
			quick_attack_buffer = true
			slow_attack_buffer = false
			
			attack_buffer_counter = 0
			
		elif Input.is_action_just_pressed("ui_down"):
			quick_attack_buffer = false
			slow_attack_buffer = true
			
			attack_buffer_counter = 0
			
	if attack_buffer_counter < attack_buffer_delay:
		attack_buffer_counter += 1
	else:
		quick_attack_buffer = false
		slow_attack_buffer = false






















func attack_inputs():
	#=============================================================================================
	var allowed_states = ["standing", "moving", "crouching"]
	if allowed_states.has(State):
	#=============================================================================================
		if Input.is_action_just_pressed("ui_right"):
			$AnimatedSprite.play("parry_blue")
			set_state("parry_blue", "right parry")
			
		elif Input.is_action_just_pressed("ui_left"):
			$AnimatedSprite.play("parry_red")
			set_state("parry_red", "left parry")
			
		elif Input.is_action_just_pressed("ui_up") or quick_attack_buffer:
			$AnimatedSprite.play("quick_attack")
			set_state("attacking", "quick_attack")
			quick_attack_buffer = false
		
			
		elif Input.is_action_just_pressed("ui_down") or slow_attack_buffer:
			$AnimatedSprite.play("slow_attack")
			set_state("attacking", "slow_attack")
	
	if not $AnimatedSprite.animation == "parry_red_fail" and State_old == "parry_red" and State == "attacking" and Input.is_action_just_pressed("ui_left"):
		$AnimatedSprite.play("parry_red")
		$AnimatedSprite.frame = 0
		set_state("parry_red", "left parry")
		
		
			
			
		
		
		
















# walk  pre_run_right run
var ground_movement_state = "walk"
var second_input_run_timer = 12
var second_input_run_counter = 0

var back_dash_state = "wait"
var second_input_back_dash_timer = 10
var second_input_back_dash_counter = 0

func ground_movement_state_input_system():
	#=============================================================================================
	var allowed_states = ["standing", "moving", "crouching", "dashing"]
	if allowed_states.has(State):
	#=============================================================================================
	
		#RUN MOVE
		if State != "crouching":
			match ground_movement_state:
				"walk":	
					if right_just:
						ground_movement_state = "pre_run_right"
						second_input_run_counter = 0
						
				"pre_run_right":
					second_input_run_counter += 1
					if second_input_run_counter < second_input_run_timer:
						if right_just:
							ground_movement_state = "run"
					elif second_input_run_counter > second_input_run_timer:
						ground_movement_state = "walk"
						second_input_run_counter = 0
							
				"run":
					if not (right or velocity_current.x > 70):
						ground_movement_state = "walk"
						#print("state set to walk!!!!!!!!!!",velocity_current.x," ",Input.is_action_just_pressed("camera_left"), " ",right_just)
	
		
		# BACK DASH MOVE
		match back_dash_state:
			"wait":
				if left_just:
					back_dash_state = "pre_dash"
					
			"pre_dash":
				second_input_back_dash_counter += 1
				if second_input_back_dash_counter < second_input_back_dash_timer and second_input_back_dash_counter > 0:
					if left_just:
						back_dash_state = "dash"
				elif second_input_back_dash_counter > second_input_back_dash_timer:
					back_dash_state = "wait"
					second_input_back_dash_counter = 0
			"dash":
				ground_movement_state = "walk"
				
				second_input_back_dash_counter = second_input_back_dash_delay
				set_state("dashing", "back_dash_state / back_dash")
				
				$AnimatedSprite.play("back_dash")
				dash_base_speed = backdash_speed
				dash_break_acceleration = back_dash_anti_accel
				
				back_dash_state = "wait"
				
		
		
		if second_input_back_dash_counter < 0:
			second_input_back_dash_counter += 1
			
	



















func crouch_check():
	#=============================================================================================
	var allowed_states = ["standing", "moving"]
	if allowed_states.has(State):
	#=============================================================================================
	
		if State != "crouching":
			if down:
				set_state("crouching", "crouching start")























	
func ground_movement_system():
	#=============================================================================================
	var allowed_states = ["standing", "moving", "crouching", "dashing", "attacking"]
	if allowed_states.has(State):
	#=============================================================================================
	
		match State:
			"dashing", "attacking":
				walk_speed = dash_base_speed
				dash_base_speed += dash_break_acceleration
				#print("dash_base_speed: ",dash_base_speed)
				
			"crouching":
				if not Input.is_action_pressed("camera_down"):
					set_state("standing", "un-crouching" )
					if second_input_back_dash_counter < -42:
						second_input_back_dash_counter = 4
						back_dash_state = "pre_dash"
	
				
			_:
				#Side movement input:
				var side_direction = 0
				if left:
					side_direction -= 1
				if right:
					side_direction += 1
			
			
			
				
				run_speed_max = 0
				run_acceleration = 0
				run_friction = 0
				
				# walk pre_run_left pre_run_right run
				if ground_movement_state == "run":
					run_speed_max = RUN_SPEED_MAX
					run_acceleration = RUN_ACCELERATION
					run_friction = RUN_FRICTION
					
					
				walk_speed += (run_acceleration + walk_acceleration) * side_direction #applies side movement input to walk_speed
				
				if walk_speed > walk_speed_max + run_speed_max: #max speed restrictor
					walk_speed = walk_speed_max + run_speed_max
				elif walk_speed < -(walk_speed_max + run_speed_max):
					walk_speed = -(walk_speed_max + run_speed_max)
					
				walk_friction_formula = walk_friction_static + walk_friction_mult * abs(velocity_current.x) * (1+run_friction)
				
				if side_direction > 0 and walk_speed < 0: #applies friction when player isn't pressing the direction he's moving to
					walk_speed += walk_friction_formula
					
				elif side_direction < 0 and walk_speed > 0: #applies friction when player isn't pressing the direction he's moving to
					walk_speed -= walk_friction_formula
					
				elif side_direction == 0:
					if walk_speed > 0:
						walk_speed -= walk_friction_formula
					elif walk_speed < 0:
						walk_speed += walk_friction_formula
					
				if abs(walk_speed) < 1: #if speed is very little makes it zero
					walk_speed = 0
			
				
				
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
func general_physics_system(delta):
	#=============================================================================================
	var allowed_states = ["standing", "moving", "dashing", "crouching", "block_stun", "hit_stun", "attacking", "parry_red", "parry_blue", "dead"]
	if allowed_states.has(State):
	#=============================================================================================
	
		velocity_current.y += gravity
		
		velocity_current.x = (velocity_current.x + walk_speed*2) / 3 #interpolates walk speed into current x velocity
		
		if controls_reversed:
			velocity_current.x = -velocity_current.x
		
		velocity_current = move_and_slide(velocity_current*delta*60)
		
		if controls_reversed:
			velocity_current.x = -velocity_current.x
		
		
		
		
		
		
		
		
		
		
		
		
		




func stun_duration_system():
	#=============================================================================================
	var allowed_states = ["block_stun", "hit_stun"]
	if allowed_states.has(State):
	#=============================================================================================
	
		if stun_duration_counter < stun_duration:
			stun_duration_counter += 1
			walk_speed = pushback_speed
		else:
			set_state("standing", "stun ended")
	
	






		
		
		
	
		
		
	
	
	
	
	
func set_state_based_on_walking():
	#=============================================================================================
	var allowed_states = ["standing", "moving"]
	if allowed_states.has(State):
	#=============================================================================================
	
		if abs(velocity_current.x) > 0.2 and State != "moving":
			set_state("moving", "bottom of general_physics_system")
		elif velocity_current.x < 0.2 and velocity_current.x > -0.2 and State != "standing":
			set_state("standing", "bottom of general_physics_system")
	
	






















func ground_animation_system():
	#=============================================================================================
	var allowed_states = ["standing", "moving"]#, "dashing", "crouching", "block_stun", "hit_stun"]
	if allowed_states.has(State):
	#=============================================================================================
	
		#if State != "dashing" and State != "crouching": #maybe should remove this if nothing weird happens here
		if velocity_current.x > 0.1:
			if abs(velocity_current.x) > 102:
				$AnimatedSprite.animation = "run"
			elif abs(velocity_current.x) > 1:
				$AnimatedSprite.animation = "walk"
			elif abs(velocity_current.x) < 1:
				$AnimatedSprite.animation = "standing"
	
		elif velocity_current.x < -0.1:
			if abs(velocity_current.x) > 102:
				$AnimatedSprite.animation = "run_rev"
			elif abs(velocity_current.x) > 1:
				$AnimatedSprite.animation = "walk_rev"
			elif abs(velocity_current.x) < 1:
				$AnimatedSprite.animation = "standing"
	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
func visual_update():
	get_parent().get_node("CanvasLayer/Player").value = health
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
#======================================================================================================================		
# ====== NON-LOOP STATE FUNCTIONS BELOW =============== NON-LOOP STATE FUNCTIONS BELOW ================================		
#======================================================================================================================	
		

#======================================================================================================================		
# ====== NON-LOOP STATE FUNCTIONS BELOW =============== NON-LOOP STATE FUNCTIONS BELOW ================================		
#======================================================================================================================	


#======================================================================================================================		
# ====== NON-LOOP STATE FUNCTIONS BELOW =============== NON-LOOP STATE FUNCTIONS BELOW ================================		
#======================================================================================================================	


















	
func readout():
	print(" ")
	print("animation: ",$AnimatedSprite.animation, " frame: ", $AnimatedSprite.frame)
	print("ground_movement_state:", ground_movement_state)
	print("back_dash_state: ", back_dash_state)
	print("State: ", State)
	print(scale)
	print(scale.x)
	print(" ")




















var controls_reversed = false

var left = false
var left_just = false

var right = false
var right_just = false

var down = false
var down_just = false


func input_translator(): #translates player inputs into variables for easier reading and for easier reversal when character and enemy switch places
	
	left = false
	left_just = false
	right = false
	right_just = false
	down = false
	down_just = false
	

	if global_position.x > get_node("../BadPlayer").global_position.x:
		if controls_reversed != true:
			scale = Vector2(-1,1)
			controls_reversed = true
			
			
			
	else:
		
		scale = Vector2(1,1)
		controls_reversed = false
			
			
	if controls_reversed:
		if Input.is_action_pressed("camera_left"):
			right = true
		if Input.is_action_just_pressed("camera_left"):
			right_just = true

		if Input.is_action_pressed("camera_right"):
			left = true
		if Input.is_action_just_pressed("camera_right"):
			left_just = true	

	else:
		if Input.is_action_pressed("camera_left"):
			left = true
		if Input.is_action_just_pressed("camera_left"):
			left_just = true
		
		if Input.is_action_pressed("camera_right"):
			right = true
		if Input.is_action_just_pressed("camera_right"):
			right_just = true

	
	if Input.is_action_pressed("camera_down"):
		down = true
	
	if Input.is_action_just_pressed("camera_down"):
		down_just = true






















var last_color_received = "dunno"


func attack_received(damage, ch_damage, is_high, color, block_stun, hit_stun, ch_stun, pushback):
		if not State == "dead":
			last_color_received = color
			match State: #HIGH ATTACKS
				"standing","block_stun","moving":
					match color:					
						"white":
							if not State == "moving":
								blocked(block_stun, pushback)
							else:
								if velocity_current.x < 0  and not right:
									blocked(block_stun, pushback)
								else:
									got_hit(damage, hit_stun, pushback)
														
						"red":
							got_hit(damage, hit_stun, pushback)
						
						"blue":
							got_hit(damage, hit_stun, pushback)
						"yellow":
							got_hit(damage, hit_stun, pushback)
	
				"crouching":
					if not is_high:
						got_hit(damage, hit_stun, pushback)
					else:
						pass #attack whiffs
						
				"dashing","hit_stun": #normal hit
					got_hit(damage, hit_stun, pushback)
					pass
	
				"attacking": #counter hit
					got_hit(ch_damage, ch_stun, pushback)
					
				"parry_red":
					if color == "red":
						Global.emit_signal("shake", true)
						$AnimatedSprite.play("parry_red_counter")
						set_state("attacking", "parry_red 21")
						spawn_effect("red_parry")
						Global.emit_signal("counter_sound")
						Global.emit_signal("large_light", global_position, Color(1,0.5,0.1,1), 10, 0.5, 0.05, 2.5)
						
					else:
						got_hit(ch_damage, ch_stun, pushback)
						
				"parry_blue":
					if color == "blue":
						Global.emit_signal("shake", true)
						$AnimatedSprite.play("parry_blue_counter")
						set_state("attacking", "parry_blue 12")
						Global.emit_signal("narukami")
						spawn_effect("blue_parry")
						Global.emit_signal("counter_sound")
						Global.emit_signal("large_light", global_position, Color(0,0.3,1,1), 10, 1, 0.05, 2.5)
						
					else:
						got_hit(ch_damage, ch_stun, pushback)
					
	
	

























var pushback_speed = 0
var stun_duration = 0
var stun_duration_counter = 0

func blocked(hit_stun, pushback):
	Global.emit_signal("block_sound")
	pushback_speed = pushback
	stun_duration = hit_stun
	stun_duration_counter = 0
	spawn_effect("block")
	set_state("block_stun", "blocked func")


















	
func got_hit(damage, hit_stun, pushback):
	spawn_effect("hit")
	Global.emit_signal("killu_hurt")
	var is_big = false
	if damage > 19:
		is_big = true
		spawn_effect("heavy_strike")
		
	else:
		spawn_effect("normal_strike")
	Global.emit_signal("hit_sound", is_big)
	Global.emit_signal("player_got_hit")
	
	
	pushback_speed = pushback
	stun_duration = hit_stun
	stun_duration_counter = 0
	
	
	health -= damage
	if health <= 0:
		set_state("dead", "dead")
	else:
		set_state("hit_stun", "hit func")
		
	if damage >= 25:
		Global.emit_signal("shake", true)
	elif damage < 25 and damage > 19:
		Global.emit_signal("shake", false)
	
	
		
	if damage >= 30:
		Global.emit_signal("pause", 4)
		
		
	elif damage < 30 and damage > 20:
		Global.emit_signal("pause", 1)	






















#(damage, ch_damage, block_stun, hit_stun, ch_stun, pushback)

func send_attack(area_name):
	match area_name:
		"quick_attack":
			get_node("../BadPlayer").attack_received(10, 10, 10, 20, 20, +30, false)
		"slow_attack":
			get_node("../BadPlayer").attack_received(20, 20, 15, 30, 30, +20, false)
		"lightning":
			get_node("../BadPlayer").attack_received(25, 25, 15, 40, 40, +20, true)

	



















func check_collision(area_name):
	match area_name:
		"quick_attack":
			if quick_attack_connects:
				send_attack(area_name)
		"slow_attack":
			if slow_attack_connects:
				send_attack(area_name)
		"lightning":
			if lightning_connects:
				send_attack(area_name)






	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	



func _on_AnimatedSprite_animation_finished():
	match $AnimatedSprite.animation:
		"back_dash":
			set_state("standing", "back_dash / _on_AnimatedSprite_animation_finished")
		
		"crouch_start":
			$AnimatedSprite.animation = "crouch_loop"
		
		"stun_block_end", "stun_hit_end":
			$AnimatedSprite.animation = "standing"
			
		"parry_blue":
			$AnimatedSprite.play("parry_blue_fail")
			set_state("attacking", "321")
			
		"parry_red":
			$AnimatedSprite.play("parry_red_fail")
			set_state("attacking", "123")
			
		"parry_blue_fail","parry_red_fail","parry_blue_counter","parry_red_counter":
			set_state("standing", "parry_blue_fail - parry_red_fail")
		
		_:
			if State == "attacking":
				set_state("standing", "if State == attacking:")

	
















func woosh_sound(is_big):
	Global.emit_signal("woosh", is_big)







func _on_AnimatedSprite_frame_changed():
	match $AnimatedSprite.animation:
		"slow_attack":
			if $AnimatedSprite.frame == 6:
				dash_base_speed = 1000
				dash_break_acceleration = 20
			if $AnimatedSprite.frame == 7:
				woosh_sound(true)
			if $AnimatedSprite.frame == 8:
				dash_base_speed = 0
				dash_break_acceleration = 0
			if $AnimatedSprite.frame == 9:
				check_collision("slow_attack")
				
		"quick_attack":
			if $AnimatedSprite.frame == 1:
				dash_base_speed = 1500
				dash_break_acceleration = -100
				woosh_sound(false)	
			if $AnimatedSprite.frame == 2:
				dash_base_speed = 0
				dash_break_acceleration = 0
				check_collision("quick_attack")
				
		"parry_blue_counter":
			match $AnimatedSprite.frame:
				2: 
					$Lightning.play("lightning")
					Global.emit_signal("large_light", global_position, Color(0,0.3,1,1), 20, 1.5, 0.1, 2) #(position, color, size, power, start_time, end_time)
					$Lightning.frame = 0
				3:
					check_collision("lightning")

		
		





















var quick_attack_connects = false

func _on_quick_attack_body_entered(body):
	if body.name == "BadPlayer":
		quick_attack_connects = true
func _on_quick_attack_body_exited(body):
	if body.name == "BadPlayer":
		quick_attack_connects = false





var slow_attack_connects = false

func _on_slow_attack_body_entered(body):
	if body.name == "BadPlayer":
		slow_attack_connects = true
func _on_slow_attack_body_exited(body):
	if body.name == "BadPlayer":
		slow_attack_connects = false





var lightning_connects = false

func _on_lightning_body_entered(body):
	if body.name == "BadPlayer":
		lightning_connects = true
func _on_lightning_body_exited(body):
	if body.name == "BadPlayer":
		lightning_connects = false

























const BLUE_PARRY_PARTICLE = preload("res://second platformer character controller/BlueParryEffect.tscn")
const RED_PARRY_PARTICLE = preload("res://second platformer character controller/RedParryEffect.tscn")
const HIT_PARTICLE = preload("res://second platformer character controller/HitEffect.tscn")
const BLOCK_PARTICLE = preload("res://second platformer character controller/BlockEffect.tscn")
const PRE_RED_PARRY_PARTICLE = preload("res://second platformer character controller/PreParryRed.tscn")
const PRE_BLUE_PARRY_PARTICLE = preload("res://second platformer character controller/PreParryBlue.tscn")
const NORMAL_STRIKE = preload("res://second platformer character controller/NormalStrikeEffect.tscn")
const HEAVY_STRIKE = preload("res://second platformer character controller/HeavyStrikeEffect.tscn")

func spawn_effect(name):
	var temp_effect = null
	match name:
		"block":
			temp_effect = BLOCK_PARTICLE.instance()
			Global.emit_signal("large_light", global_position, Color(1,1,1,1), 2.5, 0.5, 0.1, 0.5) #(position, color, size, power, start_time, end_time)
			continue
			
		"hit":
			temp_effect = HIT_PARTICLE.instance()
			continue
			
		"red_parry":
			temp_effect = RED_PARRY_PARTICLE.instance()
			continue
			
		"blue_parry":
			temp_effect = BLUE_PARRY_PARTICLE.instance()
			continue
			
		"blue_pre_parry":
			temp_effect = PRE_BLUE_PARRY_PARTICLE.instance()
			temp_effect.global_position = $Position2D.global_position
			
		"red_pre_parry":
			temp_effect = PRE_RED_PARRY_PARTICLE.instance()
			temp_effect.global_position = $Position2D.global_position
			
		"normal_strike":
			temp_effect = NORMAL_STRIKE.instance()
			temp_effect.the_color = last_color_received
			Global.emit_signal("large_light", global_position, last_color_received, 3, 0.6, 0.1, 1.1) #(position, color, size, power, start_time, end_time)
			continue
			
		"heavy_strike":
			temp_effect = HEAVY_STRIKE.instance()
			temp_effect.the_color = last_color_received
			Global.emit_signal("large_light", global_position, last_color_received, 6, 0.6, 0.1, 1.5) #(position, color, size, power, start_time, end_time)
			continue
			
		_:
			temp_effect.position.y -= 10
			temp_effect.global_position = global_position
			
	get_parent().add_child(temp_effect)


