extends KinematicBody2D



#TODO make Dio counter attack when he's attacking the wrong time? 
#make two counter attacks, one that might trigger after he's instead of normally blocking and one that triggers every time after being attacked in red or blue state
#make attacks that can be punished on block
#make attacks that are avoided by backdashing
#some long range attack

#make combos that do mid, mid, high or mid mid blue/red ---



# "standing", "punishable", "crouching", "block_stun", "hit_stun", "attacking"
var level = 0
var health = 180
var max_health = 180



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



var attack_timer = 100
var attack_timer_counter = 0



var dead_timer = 150
var dead_timer_counter = 0


var frame_counter = 0



func _ready():
	Global.connect("start_match",self,"start_match")
	level = Global.highest_level
	pass
#	available_move_list_maker()

var begin = false
func start_match():
	begin = true

# standing, block_stun, hit_stun, attacking, punishable, reversing


func set_state(new_state, who_did_the_change):
	
	#print("DIO: state changed by: ", who_did_the_change," into: ", new_state, " at frame: ",frame_counter, "at timer_counter: ",timer_counter)
	
	State_old = State
	State = new_state
	
	
	
	
	match State_old:
		"reversing":emit_aura("aws", false)
		"attacking":
			pass
		"dead":dead_timer_counter = 0	
		
		
		
		

	match new_state:
		"standing":
			#timer_counter = 0
			dash_base_speed = 0
			dash_break_acceleration = 0
			emit_aura("red", false)
			match State_old:
				"hit_stun","block_stun":
					walk_speed = 0
					velocity_current.x = 0
					$AnimatedSprite.play("standing")
				_:
					$AnimatedSprite.animation = "standing"
					if State_old == "dashing":
						velocity_current.x = 0
			
		"block_stun":
			$AnimationPlayer.stop(true)
			$AnimatedSprite.play("stun_block_loop")
		
		"hit_stun":
			$Tween.stop_all()
			$AnimationPlayer.stop(true)
			$Stand.set_value(0)
			
			
		"attacking":
			timer_counter -= 3
			if $AnimatedSprite.animation == "reversal":
				$Stand.set_value(0)
#			walk_speed = 0
#			velocity_current.x = 0
		"reversing":
			pass
		"winner":
			Global.emit_signal("hahaha")
			$AnimationPlayer.stop(true)
			$AnimatedSprite.play("winner")
		"dead":
			$AnimationPlayer.stop(true)
			$AnimatedSprite.play("dead")
			$AnimatedSprite.animation = "dead"
			Global.emit_signal("baddy_dead")
			walk_speed = 0
			velocity_current.x = 0
			
			
		
		
	

	

	


	
	
	
	
	
	
	
	
	
	
	
	
	



var start_timer = 5
var start_timer_counter = 0

	
	
	
	
	
func _physics_process(delta):
	frame_counter += 1
	
	if begin:
		
		if start_timer_counter < start_timer:
			start_timer_counter += 1
		elif start_timer_counter == start_timer:
			start_timer_counter += 1
			Global.emit_signal("play_sound","fight", 1, -10)
			
		
		
		
		#readout()
		
		situation_tracker()
		
		input_translator()
		
		stun_duration_system()
		
		#attack_buffer_system()
		
		if not State == "winner":
			attack_inputs()
		
		#crouch_check()
		
		#ground_movement_state_input_system()
		
		ground_movement_system()
		
		dash_system()
		
		general_physics_system(delta)
		
		#set_state_based_on_walking()
		
		#ground_animation_system()
		
		visual_update()
		
		resurraction()
		
		
		match State:
			"standing":pass
			"moving":pass
			"dashing":pass
			"block_stun":pass
			"hit_stun":pass
			"attacking":pass
				#walk_speed = 0
	
				
				
			
			
			
			
			
			
			
			
			
var timer = 20
var timer_counter = 0
			
func attack_inputs():
	
	
	if State == "standing":
		if timer_counter < timer:
			if not $AnimationPlayer.is_playing():
				timer_counter += 1
		else:
			timer_counter = 0
			timer = (randi()%3)+1+abs((1*(5-level)))
			
			if level > 1:
				if randi()%(4+level) == 0:
					timer += ((randi()%15)+5)-level

			available_move_list_maker()
			
			
			
#	if Input.is_action_just_pressed("dio_attack1"):
#		white_attack()
#	elif Input.is_action_just_pressed("dio_attack2"):
#		red_kick()
#	elif Input.is_action_just_pressed("dio_attack3"):
#		blue_attack()
#	elif Input.is_action_just_pressed("dio_attack4"):
#		dash_empty()
#	elif Input.is_action_just_pressed("dio_attack5"):
#		dash_attack()
#	elif Input.is_action_just_pressed("dio_attack6"):
#		white_kicks()
#	elif Input.is_action_just_pressed("dio_attack7"):
#		reversal()
#	elif Input.is_action_just_pressed("dio_attack8"):
#		slow_unblockable()
#	elif Input.is_action_just_pressed("dio_attack9"):
#		block_punishable()
#	elif Input.is_action_just_pressed("dio_attack10"):
#		short_unblockable()
#	elif Input.is_action_just_pressed("dio_attack11"):
#		jump_attack()
#	elif Input.is_action_just_pressed("dio_attack12"):
#		block_punishable2()
#	elif Input.is_action_just_pressed("dio_attack13"):
#		red_stand_kicks()
#	elif Input.is_action_just_pressed("dio_attack14"):
#		quick_unblockable()
	#elif Input.is_action_just_pressed("tween"):
	#	$AnimationPlayer.play("crouch_combo2")
		
		
	
	
	









	
	
	
	
	
	
	
	
	
	
func general_physics_system(delta):
	#=============================================================================================
	var allowed_states = ["standing", "punishable", "crouching", "block_stun", "hit_stun", "attacking", "reversing"]
	if allowed_states.has(State):
	#=============================================================================================

		velocity_current.y += gravity
		
		velocity_current.x = (velocity_current.x + walk_speed) / 3 #interpolates walk speed into current x velocity
		
		velocity_current = move_and_slide(velocity_current*delta*60)
		#print("walk_speed: ",walk_speed, " - velocity_current.x: ",velocity_current.x)
		
		
		
		
		
		
		
		
		
		
		
		


















func dash_system():
	#=============================================================================================
	var allowed_states = ["dashing", "attacking", "reversing"]
	if allowed_states.has(State):
	#=============================================================================================
		walk_speed = dash_base_speed
		dash_base_speed += dash_break_acceleration
		if dash_base_speed > 0:
			dash_base_speed = 0






















	
func ground_movement_system():
	#=============================================================================================
	var allowed_states = ["standing", "moving", "crouching", "dashing", "attacking", "reversing"]
	if allowed_states.has(State):
	#=============================================================================================
	

		walk_friction_formula = walk_friction_static + walk_friction_mult * abs(walk_speed) * (1+run_friction)
		
		if  walk_speed < 0: #applies friction when player isn't pressing the direction he's moving to
			walk_speed += walk_friction_formula
			
		elif walk_speed > 0: #applies friction when player isn't pressing the direction he's moving to
			walk_speed -= walk_friction_formula
			
		if abs(walk_speed) < 1: #if speed is very little makes it zero
			walk_speed = 0
	
				
				
	
	
	
	
	
	
	
	
	
	
	
	
	


		

	
	
	
	
	
	
				




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




















func resurraction():
	if State == "dead" and level < 5:
		if dead_timer_counter < dead_timer:
			dead_timer_counter += 1
		elif dead_timer_counter == dead_timer:
			dead_timer_counter += 1
			$AnimatedSprite.play("resurrect")
			Global.emit_signal("resurrect")
			Global.emit_signal("play_sound",str("round",level+2), 1, -10)







	
	
	
	
	
	
	







func stun_duration_system():
	
	if State == "block_stun" or State == "hit_stun":
		if stun_duration_counter < stun_duration:
			stun_duration_counter += 1
			walk_speed = pushback_speed
		else:
			set_state("standing", "stun ended")
	
	










#1 block punish, all parries
#2 + interrupt, backdash
#3 + combos/crouching
#4 + switcharoo/cancels
#5 everything, 1.03
#6 everything, 1.1








			
var available_attacks_dic = {}		
var weight_list = []
			
func available_move_list_maker():
	#print("AN ATTACK IS BEING SELECTED")
	available_attacks_dic = {}
	weight_list = []

	var total_weight
	for i in 16: #==================================================================================== how many attacks exist in total
		var temp_results = call( str("seq_",i) , false)
		if temp_results != null:
			available_attacks_dic[temp_results[1]] = int(temp_results[0] / 2)

	for i in available_attacks_dic.keys():
		var temp_num = available_attacks_dic[i]
		for x in temp_num:
			weight_list.append(i)

	#print("")
	#print(available_attacks_dic)
	#print("")

	attack_selector()



			
			
func attack_selector():
	var rng_number = randi() % weight_list.size()
	var temp_name = call(weight_list[rng_number], true)
	$AnimationPlayer.stop(true)
	
	$Stand.playing = false
	$Stand.set_value(0)
	$Tween.stop_all()

	$AnimationPlayer.play(temp_name)
				
	
			
			
			
			
			
#=====================================================================================================================		
#=====================================================================================================================			
#=====================================================================================================================
			
var seq_zz_just_used = false
var seq_zz_recent = false
var seq_zz_select_bonus = 0

func seq_zz(set_just_used):
	var seq_name = "test"
	
	if set_just_used:
		seq_zz_just_used = true
		seq_zz_select_bonus = 0
		return seq_name
	else:
		var weight = 100 #base weight ======================================================
		seq_zz_select_bonus = 10 + int(seq_zz_select_bonus*1.2)
		if seq_zz_recent:
			weight -= 50
			seq_zz_recent = false
		
		if seq_zz_just_used: #if the move was just used
			seq_zz_just_used = false
			seq_zz_recent = true
			weight -= int(weight/3)
		
		match current_range: #=================================================
			0: weight += 10
			1: weight -= 10
			2: weight = -2000
				
		match level: #======================================================
			1: weight += 20 #bonus
			2: pass #neutral
			3,4,5,0: weight = -2000 #banned
		
	
		if weight > 0:
			return [(weight + seq_zz_select_bonus), "seq_zz"]
		else:
			seq_zz_select_bonus = 0
			return null
			
			
			
#=====================================================================================================================		
#=====================================================================================================================			
#=====================================================================================================================

var seq_0_just_used = false
var seq_0_recent = false
var seq_0_select_bonus = 0

func seq_0(set_just_used):
	var seq_name = "red_kick"
	
	if set_just_used:
		seq_0_just_used = true
		seq_0_select_bonus = 0
		return seq_name
	else:
		var weight = 60 #base weight ======================================================
		seq_0_select_bonus = 10 + int(seq_0_select_bonus*1.2)
		if seq_0_recent:
			weight -= 50
			seq_0_recent = false
		
		if seq_0_just_used: #if the move was just used
			seq_0_just_used = false
			seq_0_recent = true
			weight -= int(weight/3)
		
		match current_range: #=================================================
			0: weight += 0
			1: weight += 20
			2: weight = -2000
				
		match level: #======================================================
			1: weight += 20 #bonus
			0: weight = -2000 #banned
		
	
		if weight > 0:
			return [(weight + seq_0_select_bonus), "seq_0"]
		else:
			seq_0_select_bonus = 0
			return null
			
			
			
#=====================================================================================================================		
#=====================================================================================================================			
#=====================================================================================================================

var seq_1_just_used = false
var seq_1_recent = false
var seq_1_select_bonus = 0

func seq_1(set_just_used):
	var seq_name = "blue_attack"
	
	if set_just_used:
		seq_1_just_used = true
		seq_1_select_bonus = 0
		return seq_name
	else:
		var weight = 80 #base weight ======================================================
		seq_1_select_bonus = 10 + int(seq_1_select_bonus*1.2)
		if seq_1_recent:
			weight -= 50
			seq_1_recent = false
		
		if seq_1_just_used: #if the move was just used
			seq_1_just_used = false
			seq_1_recent = true
			weight -= 75
		
		match current_range: #=================================================
			0: weight += 0
			1: weight += 20
			2: weight = -2000
				
		match level: #======================================================
			1: weight += 10 #bonus
			
			0: weight = -2000 #banned
		
	
		if weight > 0:
			return [(weight + seq_1_select_bonus), "seq_1"]
		else:
			seq_1_select_bonus = 0
			return null
			
			


#=====================================================================================================================		
#=====================================================================================================================			
#=====================================================================================================================
			
var seq_2_just_used = false
var seq_2_recent = false
var seq_2_select_bonus = 0

func seq_2(set_just_used):
	var seq_name = "dash_attack"
	
	if set_just_used:
		seq_2_just_used = true
		seq_2_select_bonus = 0
		return seq_name
	else:
		var weight = 100 #base weight ======================================================
		seq_2_select_bonus = 10 + int(seq_2_select_bonus*1.2)
		if seq_2_recent:
			weight -= 50
			seq_2_recent = false
		
		if seq_2_just_used: #if the move was just used
			seq_2_just_used = false
			seq_2_recent = true
			weight -= int(weight/2)
		
		match current_range: #=================================================
			0: weight -= 100
			1: weight -= 40
			2: weight += 100
				
		match level: #======================================================
			#1: weight += 20 #bonus
			2: pass #neutral
			#0: weight = -2000 #banned
		
	
		if weight > 0:
			return [(weight + seq_2_select_bonus), "seq_2"]
		else:
			seq_2_select_bonus = 0
			return null
			
			

			
#=====================================================================================================================		
#=====================================================================================================================			
#=====================================================================================================================
			
var seq_3_just_used = false
var seq_3_recent = false
var seq_3_select_bonus = 0

func seq_3(set_just_used):
	var seq_name = "dash_empty"
	
	if set_just_used:
		seq_2_just_used = true
		seq_3_select_bonus = 0
		return seq_name
	else:
		var weight = 100 #base weight ======================================================
		seq_3_select_bonus = 10 + int(seq_3_select_bonus*1.2)
		if seq_2_recent:
			weight -= 50
			seq_2_recent = false
		
		if seq_2_just_used: #if the move was just used
			seq_2_just_used = false
			seq_2_recent = true
			weight -= int(weight/2)
		
		match current_range: #=================================================
			0: weight -= 100
			1: weight -= 60
			2: weight += 100
				
		match level: #======================================================
			#1: weight += 20 #bonus
			2: pass #neutral
			#0: weight = -2000 #banned
		
	
		if weight > 0:
			return [(weight + seq_3_select_bonus), "seq_3"]
		else:
			seq_3_select_bonus = 0
			return null
			
#=====================================================================================================================		
#=====================================================================================================================			
#=====================================================================================================================
			
var seq_4_just_used = false
var seq_4_recent = false
var seq_4_select_bonus = 0

func seq_4(set_just_used):
	var seq_name = "white_kicks"
	
	if set_just_used:
		seq_4_just_used = true
		seq_4_select_bonus = 0
		return seq_name
	else:
		var weight = 60 #base weight ======================================================
		seq_4_select_bonus = 10 + int(seq_4_select_bonus*1.2)
		if seq_4_recent:
			weight += 20
			seq_4_recent = false
		
		if seq_4_just_used: #if the move was just used
			seq_4_just_used = false
			seq_4_recent = true
			weight -= 30
		
		match current_range: #=================================================
			0: weight += 20
			1: weight -= 100
			2: weight = -2000
				
		match level: #======================================================
			#1: weight += 20 #bonus
			2: pass #neutral
			#0: weight = -2000 #banned
		
	
		if weight > 0:
			return [(weight + seq_4_select_bonus), "seq_4"]
		else:
			seq_4_select_bonus = 0
			return null
			
			
			
#=====================================================================================================================		
#=====================================================================================================================			
#=====================================================================================================================
			
var seq_5_just_used = false
var seq_5_recent = false
var seq_5_select_bonus = 0

func seq_5(set_just_used):
	var seq_name = "slow_unblockable"
	
	if set_just_used:
		seq_5_just_used = true
		seq_5_select_bonus = 0
		return seq_name
	else:
		var weight = 120 #base weight ======================================================
		seq_5_select_bonus = 10 + int(seq_5_select_bonus*1.2)
		if seq_5_recent:
			weight -= 50
			seq_5_recent = false
		
		if seq_5_just_used: #if the move was just used
			seq_5_just_used = false
			seq_5_recent = true
			weight -= 100
		
		match current_range: #=================================================
			0: weight += 10
			1: weight -= 10
			2: weight = -2000
				
		match level: #======================================================
			2: weight += 40 #bonus
			#2: pass #neutral
			1,0: weight = -20000 #banned
		
	
		if weight > 0:
			return [(weight + seq_5_select_bonus), "seq_5"]
		else:
			seq_5_select_bonus = 0
			return null
			
			
#=====================================================================================================================		
#=====================================================================================================================			
#=====================================================================================================================
			
var seq_6_just_used = false
var seq_6_recent = false
var seq_6_select_bonus = 0

func seq_6(set_just_used):
	var seq_name = "block_punishable"
	
	if set_just_used:
		seq_6_just_used = true
		seq_6_select_bonus = 0
		return seq_name
	else:
		var weight = 100 #base weight ======================================================
		seq_6_select_bonus = 10 + int(seq_6_select_bonus*1.2)
		if seq_6_recent:
			weight -= 30
			seq_6_recent = false
		
		if seq_6_just_used: #if the move was just used
			seq_6_just_used = false
			seq_6_recent = true
			weight -= 100
		
		match current_range: #=================================================
			0: weight += 0
			1: weight -= 20
			2: weight = -2000
				
		match level: #======================================================
			1: weight += 20 #bonus
			0: weight += 60
			#0: weight = -20000 #banned
		
	
		if weight > 0:
			return [(weight + seq_6_select_bonus), "seq_6"]
		else:
			seq_6_select_bonus = 0
			return null
			
			
#=====================================================================================================================		
#=====================================================================================================================			
#=====================================================================================================================
			
var seq_7_just_used = false
var seq_7_recent = false
var seq_7_select_bonus = 0

func seq_7(set_just_used):
	var seq_name = "short_unblockable"
	
	if set_just_used:
		seq_7_just_used = true
		seq_7_select_bonus = 0
		return seq_name
	else:
		var weight = 80 #base weight ======================================================
		seq_7_select_bonus = 10 + int(seq_7_select_bonus*1.2)
		if seq_7_recent:
			weight -= 50
			seq_7_recent = false
		
		if seq_7_just_used: #if the move was just used
			seq_7_just_used = false
			seq_7_recent = true
			weight -= int(weight/3)
		
		match current_range: #=================================================
			0: weight += 0
			1: weight -= 50
			2: weight = -2000
				
		match level: #======================================================
			1,0: weight -= 1000 #bonus
			#2: pass #neutral
			2: weight += 20 #banned
		
	
		if weight > 0:
			return [(weight + seq_7_select_bonus), "seq_7"]
		else:
			seq_7_select_bonus = 0
			return null
			
			
#=====================================================================================================================		
#=====================================================================================================================			
#=====================================================================================================================
			
var seq_8_just_used = false
var seq_8_recent = false
var seq_8_select_bonus = 0

func seq_8(set_just_used):
	var seq_name = "block_punishable2"
	
	if set_just_used:
		seq_8_just_used = true
		seq_8_select_bonus = 0
		return seq_name
	else:
		var weight = 100 #base weight ======================================================
		seq_8_select_bonus = 10 + int(seq_8_select_bonus*1.2)
		if seq_8_recent:
			weight -= 50
			seq_8_recent = false
		
		if seq_8_just_used: #if the move was just used
			seq_8_just_used = false
			seq_8_recent = true
			weight -= int(weight/3)
		
		match current_range: #=================================================
			0: weight += 10
			1: weight -= 10
			2: weight = -2000
				
		match level: #======================================================
			1: weight += 20 #bonus
			0: weight += 50 #neutral
			#0: weight = -2000 #banned
		
	
		if weight > 0:
			return [(weight + seq_8_select_bonus), "seq_8"]
		else:
			seq_8_select_bonus = 0
			return null
			
			
#=====================================================================================================================		
#=====================================================================================================================			
#=====================================================================================================================
			
var seq_9_just_used = false
var seq_9_recent = false
var seq_9_select_bonus = 0

func seq_9(set_just_used):
	var seq_name = "red_stand_kicks"
	
	if set_just_used:
		seq_9_just_used = true
		seq_9_select_bonus = 0
		return seq_name
	else:
		var weight = 100 #base weight ======================================================
		seq_9_select_bonus = 10 + int(seq_9_select_bonus*1.2)
		if seq_9_recent:
			weight -= 50
			seq_9_recent = false
		
		if seq_9_just_used: #if the move was just used
			seq_9_just_used = false
			seq_9_recent = true
			weight -= int(weight/3)
		
		match current_range: #=================================================
			0: weight += 0
			1: weight += 10
			2: weight = -2000
				
		match level: #======================================================
			1: weight += 20 #bonus
			#2: pass #neutral
			0: weight = -2000 #banned
		
	
		if weight > 0:
			return [(weight + seq_9_select_bonus), "seq_9"]
		else:
			seq_9_select_bonus = 0
			return null
			
			

			
#=====================================================================================================================		
#=====================================================================================================================			
#=====================================================================================================================
			
var seq_10_just_used = false
var seq_10_recent = false
var seq_10_select_bonus = 0

func seq_10(set_just_used):
	var seq_name = "white_punch"
	
	if set_just_used:
		seq_10_just_used = true
		seq_10_select_bonus = 0
		return seq_name
	else:
		var weight = 50 #base weight ======================================================
		seq_10_select_bonus = 10 + int(seq_10_select_bonus*1.2)
		if seq_10_recent:
			weight -= -10
			seq_10_recent = false
		
		if seq_10_just_used: #if the move was just used
			seq_10_just_used = false
			seq_10_recent = true
			weight -= int(weight/3)
		
		match current_range: #=================================================
			0: weight += 10
			1: weight -= 50
			2: weight = -2000
				
		match level: #======================================================
			#1: weight += 20 #bonus
			2: pass #neutral
			#0: weight = -2000 #banned
		
		if weight > 0:
			return [(weight + seq_10_select_bonus), "seq_10"]
		else:
			seq_10_select_bonus = 0
			return null
			
			
#=====================================================================================================================		
#=====================================================================================================================			
#=====================================================================================================================
			
var seq_11_just_used = false
var seq_11_recent = false
var seq_11_select_bonus = 0

func seq_11(set_just_used):
	var seq_name = "jump_attack"
	
	if set_just_used:
		seq_11_just_used = true
		seq_11_select_bonus = 0
		return seq_name
	else:
		var weight = 50 #base weight ======================================================
		seq_11_select_bonus = 10 + int(seq_11_select_bonus*1.2)
		if seq_11_recent:
			weight -= 50
			seq_11_recent = false
		
		if seq_11_just_used: #if the move was just used
			seq_11_just_used = false
			seq_11_recent = true
			weight -= int(weight/3)
		
		match current_range: #=================================================
			0: weight += 10
			1: weight -= 10
			2: weight = -2000
				
		match level: #======================================================
			#1: weight += 20 #bonus
			2: pass #neutral
			#0: weight = -2000 #banned
		
	
		if weight > 0:
			return [(weight + seq_11_select_bonus), "seq_11"]
		else:
			seq_11_select_bonus = 0
			return null
			
			
#=====================================================================================================================		
#=====================================================================================================================			
#=====================================================================================================================
			
var seq_12_just_used = false
var seq_12_recent = false
var seq_12_select_bonus = 0

func seq_12(set_just_used):
	var seq_name = "crouch_combo1"
	
	if set_just_used:
		seq_12_just_used = true
		seq_12_select_bonus = 0
		return seq_name
	else:
		var weight = 100 #base weight ======================================================
		seq_12_select_bonus = 10 + int(seq_12_select_bonus*1.2)
		if seq_12_recent:
			weight -= 50
			seq_12_recent = false
		
		if seq_12_just_used: #if the move was just used
			seq_12_just_used = false
			seq_12_recent = true
			weight -= int(weight/3)
		
		match current_range: #=================================================
			0: weight += 0
			1: weight -= 10
			2: weight =  40
				
		match level: #======================================================
			3: weight += 10 #bonus
			#1: pass #neutral
			1,2,0: weight = -20000 #banned
		
	
		if weight > 0:
			return [(weight + seq_12_select_bonus), "seq_12"]
		else:
			seq_12_select_bonus = 0
			return null
			
			
#=====================================================================================================================		
#=====================================================================================================================			
#=====================================================================================================================
			
var seq_13_just_used = false
var seq_13_recent = false
var seq_13_select_bonus = 0

func seq_13(set_just_used):
	var seq_name = "crouch_combo2"
	
	if set_just_used:
		seq_13_just_used = true
		seq_13_select_bonus = 0
		return seq_name
	else:
		var weight = 100 #base weight ======================================================
		seq_13_select_bonus = 10 + int(seq_13_select_bonus*1.2)
		if seq_13_recent:
			weight -= 50
			seq_13_recent = false
		
		if seq_13_just_used: #if the move was just used
			seq_13_just_used = false
			seq_13_recent = true
			weight -= int(weight/3)
		
		match current_range: #=================================================
			0: weight += 20
			1: weight -= 0
			2: weight = -2000
				
		match level: #======================================================
			3: weight += 10 #bonus
			1,2,0: weight = -20000 #banned
		
	
		if weight > 0:
			return [(weight + seq_13_select_bonus), "seq_13"]
		else:
			seq_13_select_bonus = 0
			return null
			
			
#=====================================================================================================================		
#=====================================================================================================================			
#=====================================================================================================================
			
var seq_14_just_used = false
var seq_14_recent = false
var seq_14_select_bonus = 0

func seq_14(set_just_used):
	var seq_name = "crouch_combo3"
	
	if set_just_used:
		seq_14_just_used = true
		seq_14_select_bonus = 0
		return seq_name
	else:
		var weight = 100 #base weight ======================================================
		seq_14_select_bonus = 10 + int(seq_14_select_bonus*1.2)
		if seq_14_recent:
			weight -= 50
			seq_14_recent = false
		
		if seq_14_just_used: #if the move was just used
			seq_14_just_used = false
			seq_14_recent = true
			weight -= int(weight/3)
		
		match current_range: #=================================================
			0: weight += 10
			1: weight -= 10
			2: weight = -2000
				
		match level: #======================================================
			4: weight += 30 #bonus
			1,2,3,0: weight = -20000 #banned
		
	
		if weight > 0:
			return [(weight + seq_14_select_bonus), "seq_14"]
		else:
			seq_14_select_bonus = 0
			return null
			
			
#=====================================================================================================================		
#=====================================================================================================================			
#=====================================================================================================================
			
var seq_15_just_used = false
var seq_15_recent = false
var seq_15_select_bonus = 0

func seq_15(set_just_used):
	var seq_name = "crouch_combo4"
	
	if set_just_used:
		seq_15_just_used = true
		seq_15_select_bonus = 0
		return seq_name
	else:
		var weight = 100 #base weight ======================================================
		seq_15_select_bonus = 10 + int(seq_15_select_bonus*1.2)
		if seq_15_recent:
			weight -= 50
			seq_15_recent = false
		
		if seq_15_just_used: #if the move was just used
			seq_15_just_used = false
			seq_15_recent = true
			weight -= int(weight/3)
		
		match current_range: #=================================================
			0: weight += 10
			1: weight -= 10
			2: weight = -2000
				
		match level: #======================================================
			4: weight += 40 #bonus
			#2: pass #neutral
			1,2,3,0: weight = -20000 #banned
		
	
		if weight > 0:
			return [(weight + seq_15_select_bonus), "seq_15"]
		else:
			seq_15_select_bonus = 0
			return null
			
			
#=====================================================================================================================		
#=====================================================================================================================			
#=====================================================================================================================
			
var seq_16_just_used = false
var seq_16_recent = false
var seq_16_select_bonus = 0

func seq_16(set_just_used):
	var seq_name = "test"
	
	if set_just_used:
		seq_16_just_used = true
		seq_16_select_bonus = 0
		return seq_name
	else:
		var weight = 100 #base weight ======================================================
		seq_16_select_bonus = 10 + int(seq_16_select_bonus*1.2)
		if seq_16_recent:
			weight -= 50
			seq_16_recent = false
		
		if seq_16_just_used: #if the move was just used
			seq_16_just_used = false
			seq_16_recent = true
			weight -= int(weight/3)
		
		match current_range: #=================================================
			0: weight += 10
			1: weight -= 10
			2: weight = -2000
				
		match level: #======================================================
			1: weight += 20 #bonus
			2: pass #neutral
			3,4,5,0: weight = -2000 #banned
		
	
		if weight > 0:
			return [(weight + seq_16_select_bonus), "seq_16"]
		else:
			seq_16_select_bonus = 0
			return null
			
			
#=====================================================================================================================		
#=====================================================================================================================			
#=====================================================================================================================
			
var seq_17_just_used = false
var seq_17_recent = false
var seq_17_select_bonus = 0

func seq_17(set_just_used):
	var seq_name = "test"
	
	if set_just_used:
		seq_17_just_used = true
		seq_17_select_bonus = 0
		return seq_name
	else:
		var weight = 100 #base weight ======================================================
		seq_17_select_bonus = 10 + int(seq_17_select_bonus*1.2)
		if seq_17_recent:
			weight -= 50
			seq_17_recent = false
		
		if seq_17_just_used: #if the move was just used
			seq_17_just_used = false
			seq_17_recent = true
			weight -= int(weight/3)
		
		match current_range: #=================================================
			0: weight += 10
			1: weight -= 10
			2: weight = -2000
				
		match level: #======================================================
			1: weight += 20 #bonus
			2: pass #neutral
			3,4,5,0: weight = -2000 #banned
		
	
		if weight > 0:
			return [(weight + seq_17_select_bonus), "seq_17"]
		else:
			seq_17_select_bonus = 0
			return null
			
			
#=====================================================================================================================		
#=====================================================================================================================			
#=====================================================================================================================
			
var seq_18_just_used = false
var seq_18_recent = false
var seq_18_select_bonus = 0

func seq_18(set_just_used):
	var seq_name = "test"
	
	if set_just_used:
		seq_18_just_used = true
		seq_18_select_bonus = 0
		return seq_name
	else:
		var weight = 100 #base weight ======================================================
		seq_18_select_bonus = 10 + int(seq_18_select_bonus*1.2)
		if seq_18_recent:
			weight -= 50
			seq_18_recent = false
		
		if seq_18_just_used: #if the move was just used
			seq_18_just_used = false
			seq_18_recent = true
			weight -= int(weight/3)
		
		match current_range: #=================================================
			0: weight += 10
			1: weight -= 10
			2: weight = -2000
				
		match level: #======================================================
			1: weight += 20 #bonus
			2: pass #neutral
			3,4,5,0: weight = -2000 #banned
		
	
		if weight > 0:
			return [(weight + seq_18_select_bonus), "seq_18"]
		else:
			seq_18_select_bonus = 0
			return null
			
			
#=====================================================================================================================		
#=====================================================================================================================			
#=====================================================================================================================
			
var seq_19_just_used = false
var seq_19_recent = false
var seq_19_select_bonus = 0

func seq_19(set_just_used):
	var seq_name = "test"
	
	if set_just_used:
		seq_19_just_used = true
		seq_19_select_bonus = 0
		return seq_name
	else:
		var weight = 100 #base weight ======================================================
		seq_19_select_bonus = 10 + int(seq_19_select_bonus*1.2)
		if seq_19_recent:
			weight -= 50
			seq_19_recent = false
		
		if seq_19_just_used: #if the move was just used
			seq_19_just_used = false
			seq_19_recent = true
			weight -= int(weight/3)
		
		match current_range: #=================================================
			0: weight += 10
			1: weight -= 10
			2: weight = -2000
				
		match level: #======================================================
			1: weight += 20 #bonus
			2: pass #neutral
			3,4,5,0: weight = -2000 #banned
		
	
		if weight > 0:
			return [(weight + seq_19_select_bonus), "seq_19"]
		else:
			seq_19_select_bonus = 0
			return null
			
			
#=====================================================================================================================		
#=====================================================================================================================			
#=====================================================================================================================
			
var seq_20_just_used = false
var seq_20_recent = false
var seq_20_select_bonus = 0

func seq_20(set_just_used):
	var seq_name = "test"
	
	if set_just_used:
		seq_20_just_used = true
		seq_20_select_bonus = 0
		return seq_name
	else:
		var weight = 100 #base weight ======================================================
		seq_20_select_bonus = 10 + int(seq_20_select_bonus*1.2)
		if seq_20_recent:
			weight -= 50
			seq_20_recent = false
		
		if seq_20_just_used: #if the move was just used
			seq_20_just_used = false
			seq_20_recent = true
			weight -= int(weight/3)
		
		match current_range: #=================================================
			0: weight += 10
			1: weight -= 10
			2: weight = -2000
				
		match level: #======================================================
			1: weight += 20 #bonus
			2: pass #neutral
			3,4,5,0: weight = -2000 #banned
		
	
		if weight > 0:
			return [(weight + seq_20_select_bonus), "seq_20"]
		else:
			seq_20_select_bonus = 0
			return null
			
			
#=====================================================================================================================		
#=====================================================================================================================			
#=====================================================================================================================
			
var seq_21_just_used = false
var seq_21_recent = false
var seq_21_select_bonus = 0

func seq_21(set_just_used):
	var seq_name = "test"
	
	if set_just_used:
		seq_21_just_used = true
		seq_21_select_bonus = 0
		return seq_name
	else:
		var weight = 100 #base weight ======================================================
		seq_21_select_bonus = 10 + int(seq_21_select_bonus*1.2)
		if seq_21_recent:
			weight -= 50
			seq_21_recent = false
		
		if seq_21_just_used: #if the move was just used
			seq_21_just_used = false
			seq_21_recent = true
			weight -= int(weight/3)
		
		match current_range: #=================================================
			0: weight += 10
			1: weight -= 10
			2: weight = -2000
				
		match level: #======================================================
			1: weight += 20 #bonus
			2: pass #neutral
			3,4,5,0: weight = -2000 #banned
		
	
		if weight > 0:
			return [(weight + seq_21_select_bonus), "seq_21"]
		else:
			seq_21_select_bonus = 0
			return null
			
			
#=====================================================================================================================		
#=====================================================================================================================			
#=====================================================================================================================
			
var seq_22_just_used = false
var seq_22_recent = false
var seq_22_select_bonus = 0

func seq_22(set_just_used):
	var seq_name = "test"
	
	if set_just_used:
		seq_22_just_used = true
		seq_22_select_bonus = 0
		return seq_name
	else:
		var weight = 100 #base weight ======================================================
		seq_22_select_bonus = 10 + int(seq_22_select_bonus*1.2)
		if seq_22_recent:
			weight -= 50
			seq_22_recent = false
		
		if seq_22_just_used: #if the move was just used
			seq_22_just_used = false
			seq_22_recent = true
			weight -= int(weight/3)
		
		match current_range: #=================================================
			0: weight += 10
			1: weight -= 10
			2: weight = -2000
				
		match level: #======================================================
			1: weight += 20 #bonus
			2: pass #neutral
			3,4,5,0: weight = -2000 #banned
		
	
		if weight > 0:
			return [(weight + seq_22_select_bonus), "seq_22"]
		else:
			seq_22_select_bonus = 0
			return null
			
			
#=====================================================================================================================		
#=====================================================================================================================			
#=====================================================================================================================
			
var seq_23_just_used = false
var seq_23_recent = false
var seq_23_select_bonus = 0

func seq_23(set_just_used):
	var seq_name = "test"
	
	if set_just_used:
		seq_23_just_used = true
		seq_23_select_bonus = 0
		return seq_name
	else:
		var weight = 100 #base weight ======================================================
		seq_23_select_bonus = 10 + int(seq_23_select_bonus*1.2)
		if seq_23_recent:
			weight -= 50
			seq_23_recent = false
		
		if seq_23_just_used: #if the move was just used
			seq_23_just_used = false
			seq_23_recent = true
			weight -= int(weight/3)
		
		match current_range: #=================================================
			0: weight += 10
			1: weight -= 10
			2: weight = -2000
				
		match level: #======================================================
			1: weight += 20 #bonus
			2: pass #neutral
			3,4,5,0: weight = -2000 #banned
		
	
		if weight > 0:
			return [(weight + seq_23_select_bonus), "seq_23"]
		else:
			seq_23_select_bonus = 0
			return null
			

			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			

			
	

			
		
			
			

		
	

			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
				
var less_than_half_hp = false
var current_range = 0 #0,1,2    



func situation_tracker():
	
	if max_health-1 > health*2:
		less_than_half_hp = true
		
		
	var distance = abs(global_position.x - get_node("../GoodPlayer").global_position.x)
	if distance < 110:
		current_range = 0
	elif distance > 110 and distance < 240:
		current_range = 1
	elif distance > 240:
		current_range = 2
	
	
	
















		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
func visual_update():
	
	$State.text = State
	$Level.text = str("Level: ",level)
	
	if controls_reversed:
		$State.rect_scale.x = -1
	else:
		$State.rect_scale.x = 1
		
	get_parent().get_node("CanvasLayer/Baddy").value = health
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
#======================================================================================================================		
# ====== NON-LOOP STATE FUNCTIONS BELOW =============== NON-LOOP STATE FUNCTIONS BELOW ================================		
#======================================================================================================================	
		

#======================================================================================================================		
# ====== NON-LOOP STATE FUNCTIONS BELOW =============== NON-LOOP STATE FUNCTIONS BELOW ================================		
#======================================================================================================================	


#======================================================================================================================		
# ====== NON-LOOP STATE FUNCTIONS BELOW =============== NON-LOOP STATE FUNCTIONS BELOW ================================		
#======================================================================================================================	









func woosh_sound(is_big):
	Global.emit_signal("woosh", is_big)






	
func check_collision(area_name):
	match area_name:
		"red_kick":
			if red_kick_connects:
				send_attack(area_name)
		"white_punch":
			if white_punch_connects:
				send_attack(area_name)
		"blue_attack":
			if blue_attack_connects:
				send_attack(area_name)
		"dash_attack":
			if dash_attack_connects:
				send_attack(area_name)
		"white_kicks":
			if white_kicks_connects:
				send_attack(area_name)
		"reversal":
			if reversal_connects:
				send_attack(area_name)
		"slow_attack":
			if slow_attack_connect:
				send_attack(area_name)
		"slow_unblockable":
			if slow_unblockable_connects:
				send_attack(area_name)
		"block_punishable":
			if block_punishable_connects:
				send_attack(area_name)
		"short_unblockable":
			if short_unblockable_connects:
				send_attack(area_name)
		"jump_attack":
			if jump_attack_connects:
				send_attack(area_name)	
		"block_punishable2":
			if block_punishable2_connects:
				send_attack(area_name)	
		"red_stand_kicks":
			if red_stand_kicks_connects:
				send_attack(area_name)
		"quick_unblockable":
			if red_stand_kicks_connects:
				send_attack(area_name)
			
			
			

	
	




















func send_attack(area_name):
	match area_name:
		"red_kick":
			get_node("../GoodPlayer").attack_received(40, 45, false, "red", 10, 15, 15, -80)
		"white_punch":
			get_node("../GoodPlayer").attack_received(15, 25, true, "white", 40, 15, 15, -10)
		"blue_attack":
			get_node("../GoodPlayer").attack_received(40, 45, false, "blue", 10, 15, 15, -80)
		"dash_attack":
			get_node("../GoodPlayer").attack_received(19, 25, false, "white", 20, 20, 20, -20)
		"white_kicks":
			get_node("../GoodPlayer").attack_received(8, 10, false, "white", 20, 20, 20, -100)
		"reversal":
			get_node("../GoodPlayer").attack_received(10, 15, false, "white", 20, 20, 20, -30)
		"slow_unblockable":
			get_node("../GoodPlayer").attack_received(50, 55, false, "yellow", 20, 30, 30, -30)
		"block_punishable":
			get_node("../GoodPlayer").attack_received(30, 35, false, "white", 20, 35, 35, -70)
		"short_unblockable":
			get_node("../GoodPlayer").attack_received(40, 45, false, "yellow", 20, 35, 35, -70)
		"jump_attack":
			get_node("../GoodPlayer").attack_received(15, 25, true, "white", 30, 20, 20, -10)
		"block_punishable2":
			get_node("../GoodPlayer").attack_received(10, 15, false, "white", 9, 20, 20, -200)
		"red_stand_kicks":
			get_node("../GoodPlayer").attack_received(20, 25, false, "red", 9, 20, 20, -60)
		"quick_unblockable":
			get_node("../GoodPlayer").attack_received(20, 25, false, "yellow", 9, 20, 20, -60)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


var reversal_chance = 3

func attack_received(damage, ch_damage, block_stun, hit_stun, ch_stun, pushback, is_lightning):
	if is_lightning:
		$AnimatedSprite.play("stun_hit_ele_loop")
		Global.emit_signal("shock")
		got_hit(damage, hit_stun, pushback, is_lightning)
	else:
		match State: #HIGH ATTACKS
			"reversing":
				timer_counter -= 2
				$AnimationPlayer.stop(true)
				$AnimatedSprite.play("reversal")
				set_state("attacking", "reversal 1232")
				spawn_effect("reversal")
				Global.emit_signal("counter_sound")
				
				
			"standing","block_stun":
				#print("REVERSAL CHANCE")
				match level:
					4:reversal_chance = 2
					
				
				match randi()%reversal_chance:
					0:
						$AnimatedSprite.play("reversal")
						set_state("attacking", "block reversal")
						timer_counter = 0
						spawn_effect("reversal")
						
					_:
						blocked(hit_stun, pushback)
	
			"dashing","hit_stun","punishable": #normal hit
				got_hit(damage, hit_stun, pushback, is_lightning)
	
			"attacking": #counter hit
				got_hit(ch_damage, ch_stun, pushback, is_lightning)
			
				

	
				
			
				
				
				
				
				
				


var pushback_speed = 0
var stun_duration = 0
var stun_duration_counter = 0

func blocked(hit_stun, pushback):
	Global.emit_signal("block_sound")
	spawn_effect("block")
	pushback_speed = pushback
	stun_duration = hit_stun
	stun_duration_counter = 0
	set_state("block_stun", "blocked func")
	
	
	

				
				
				
				
				
				
				
				
				


	
func got_hit(damage, hit_stun, pushback, is_lightning):
	
	var is_big = false
	if damage > 19:
		is_big = true
		Global.emit_signal("generic_hurt", true)
	else:
		Global.emit_signal("generic_hurt", false)
	
	
	Global.emit_signal("hit_sound", is_big)
	Global.emit_signal("baddy_got_hit")
	spawn_effect("hit")
	
	pushback_speed = pushback
	stun_duration = hit_stun
	stun_duration_counter = 0
	
	if level == 0:
		health -= int(damage*1.2)
	elif level == 5:
		health -= int(damage*0.9)
	else:
		health -= damage
	
	if health <= 0:
		set_state("dead", "dead123")
	else:
		set_state("hit_stun", "hit func")
		if is_lightning:
			$AnimatedSprite.play("stun_hit_ele_loop")
		else:
			$AnimatedSprite.animation = "stun_hit_loop"
			
	if damage >= 24:
		Global.emit_signal("shake", true)
		Global.emit_signal("pause", 10)
	elif damage < 24 and damage > 19:
		Global.emit_signal("shake", false)
		#Global.emit_signal("pause", 3)		
	
			
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				


	
func readout():
	print(" ")
	print("animation: ",$AnimatedSprite.animation, " frame: ", $AnimatedSprite.frame)
	#print("ground_movement_state:", ground_movement_state)
	#print("back_dash_state: ", back_dash_state)
	print("State: ", State)
	print("timer_counter: ",timer_counter)
	#print(scale)
	#print(scale.x)
	print(" ")




				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
func _on_AnimatedSprite_animation_finished():
	match $AnimatedSprite.animation:
		"red_kick":
			set_state("standing", "anim finished1")
		
		"blue_attack":
			set_state("standing", "anim finished2")
		
		"white_punch":
			set_state("standing", "anim finished3")
			
		"dash_attack":
			set_state("standing", "anim finished4")
			
		"dash_empty":
			set_state("standing", "anim finished42")	
			timer_counter = timer - 3
			
				
		"white_kicks":
			set_state("standing", "anim finished5")
		
		"reversal":
			set_state("standing", "anim finished5")
			
		"slow_unblockable":
			set_state("standing", "anim finished7")
			
		"block_punishable":
			set_state("standing", "anim finished8")
		
		"short_unblockable":
			set_state("standing", "anim finished9")
			
		"jump_attack":
			set_state("standing", "anim finished10")
			
		"block_punishable2":
			set_state("standing", "anim finished11")
			
		"red_stand_kicks":
			set_state("standing", "anim finished12")
			
		"quick_unblockable":
			set_state("standing", "anim finished12")
		
		"resurrect":
			Global.emit_signal("play_sound","fight", 1, -10)
			level += 1
			if Global.highest_level < level:
				Global.highest_level = level
			health = max_health
			get_node("../GoodPlayer").health = get_node("../GoodPlayer").max_health
			set_state("standing", "anim finished 1323")
			
		
			
			
			
			
			
					
				
				
				
				
				
				
				
				
				
		


func _on_Stand_animation_finished():
	$Tween.interpolate_property(get_node("Stand"), "value_a", null, 0, 0.1,Tween.TRANS_LINEAR,Tween.EASE_IN,0.1)
	$Tween.start()
	Global.emit_signal("disappear")
	Global.emit_signal("humm_stop")





func _on_Tween_tween_step(object, key, elapsed, value):
	if $Stand.value_a == 0:
		$Tween.stop_all()


				
			


func _on_AnimatedSprite_frame_changed():
	var frame = $AnimatedSprite.frame
	
	if frame == 0:
		dash_base_speed = 0
		dash_break_acceleration = 0
	
	
	
	
	
	var scale = 1
	if level == 0:
		scale = 0.95
	if level >= 5 and State == "attacking":
		match frame:
			0,1,2,3:
				scale = 1.5
			4,5,6,7:
				scale = 1.02
			_: 
				scale = 1
	if $AnimatedSprite.speed_scale != scale:
		$AnimatedSprite.speed_scale = scale
	if $Stand.speed_scale != scale:
		$Stand.speed_scale = scale

	
	
	
	
	
	match $AnimatedSprite.animation:
		"red_kick":

			if frame == 9:
				Global.emit_signal("generic_attack", true)
				
			if frame == 10:
				woosh_sound(true)
				emit_aura("blue", false)
				dash_base_speed = -5000
				dash_break_acceleration = 400
				
			if frame == 11:
				check_collision("red_kick")
				
			if frame == 12:
				dash_base_speed = 0
				dash_break_acceleration = 0
				
				
		"white_punch":
			if frame == 1:
				woosh_sound(false)
				dash_base_speed = -2000
				dash_break_acceleration = 150
				Global.emit_signal("generic_attack", false)
				
			if frame == 2:
				dash_base_speed = 0
				dash_break_acceleration = 0
				check_collision("white_punch")
		
		"blue_attack":
			if frame == 0:
				Global.emit_signal("hehehe")
				
			if frame == 4:
				$Stand.play("punch_blue")
				$Stand.frame = 0
				Global.emit_signal("muda")
				$Stand.set_value(1)
				
	
			
			if frame == 5:
				dash_base_speed = -2500
				dash_break_acceleration = 150
				woosh_sound(true)
			if frame == 6:
				emit_aura("blue", false)
				dash_base_speed = 0
				dash_break_acceleration = 0
				check_collision("blue_attack")
				
		"dash_attack":
			if frame == 1:
				dash_base_speed = -7000
				dash_break_acceleration = 200
			if frame == 2:
				Global.emit_signal("generic_attack", false)
			if frame == 3:
				woosh_sound(false)
			if frame == 4:
				dash_base_speed = 0
				dash_break_acceleration = 0
				check_collision("dash_attack")
				
		"dash_empty":
			if frame == 1:
				dash_base_speed = -7000
				dash_break_acceleration = 200
			if frame == 4:
				dash_base_speed = 0
				dash_break_acceleration = 0
				
		"white_kicks":
			if frame == 0:
				dash_base_speed = -3200
				dash_break_acceleration = 200	
			if frame == 1:
				Global.emit_signal("generic_attack", true)
			if frame == 2:
				woosh_sound(false)
			if frame == 3:
				dash_base_speed = 0
				dash_break_acceleration = 0
				check_collision("white_kicks")
				
			if frame == 5:
				dash_base_speed = -1900
				dash_break_acceleration = 100
				woosh_sound(false)
			if frame == 6:
				dash_base_speed = 0
				dash_break_acceleration = 0
				check_collision("white_kicks")
				
			if frame == 8:
				dash_base_speed = -1900
				dash_break_acceleration = 100
				woosh_sound(false)
			if frame == 9:
				dash_base_speed = 0
				dash_break_acceleration = 0
				check_collision("white_kicks")
			
		"reversal":
			if frame == 0:
				
				$Stand.play("kick_white")
				$Stand.frame = 0
				$Stand.set_value(1)
				woosh_sound(false)
				
			if frame == 1:
				Global.emit_signal("mudada")
				$Stand.play("kick_white")
				$Stand.set_value(1)
				$Stand.frame = 1
				dash_base_speed = -400
				dash_break_acceleration = 10
				check_collision("reversal")
			if frame == 3:
				woosh_sound(true)
			if frame == 4:
				dash_base_speed = 0
				dash_break_acceleration = 0
				check_collision("reversal")
				
		"slow_unblockable":
			if frame == 0:
				Global.emit_signal("hehehe")
			if frame == 9:
				$Stand.play("punch")
				$Stand.frame = 0
				$Stand.set_value(1)
			if frame == 10:
				dash_base_speed = -300
				dash_break_acceleration = 20
			if frame == 11:
				dash_base_speed = -2500
				dash_break_acceleration = 150
				woosh_sound(true)
				Global.emit_signal("generic_attack", true)
			if frame == 12:
				dash_base_speed = 0
				dash_break_acceleration = 0
				check_collision("slow_unblockable")
				
		"block_punishable":
			if frame == 1 or frame == 0:
				dash_base_speed = -2500
				dash_break_acceleration = 0
			if frame == 1:
				Global.emit_signal("generic_attack", false)
				
			if frame == 2:
				dash_base_speed = 0
				dash_break_acceleration = 0
				check_collision("block_punishable")
				
		"short_unblockable":
			if frame == 5:
				$Stand.play("kick")
				$Stand.frame = 0
				$Stand.set_value(1)
			if frame == 7:
				woosh_sound(true)
				Global.emit_signal("generic_attack", false)
			if frame == 8:
				emit_aura("asd", false)
				check_collision("short_unblockable")
		
		"jump_attack":
			if frame == 1:
				dash_base_speed = -1500
				dash_break_acceleration = 0
			if frame == 3:
				woosh_sound(false)
				Global.emit_signal("generic_attack", false)
			if frame == 4:
				dash_base_speed = 0
				dash_break_acceleration = 0
				check_collision("jump_attack")
				
		"block_punishable2":
			if frame == 1 or frame == 0:
				dash_base_speed = -1000
				dash_break_acceleration = 0
			if frame == 4:
				$Stand.frame = 0
				$Stand.set_value(1)
				$Stand.play("punches_white")
				
				dash_base_speed = 0
				dash_break_acceleration = 0
				Global.emit_signal("generic_attack", true)
			match frame:
				5,6,7,8:
					check_collision("block_punishable2")
			
		"red_stand_kicks":
			match frame:
				1:
					dash_base_speed = -900
					dash_break_acceleration = 50
				4:
					dash_base_speed = 0
					dash_break_acceleration = 0
					emit_aura("red", true)
					Global.emit_signal("hahaha")
					$Stand.play("kick_red")
					$Stand.frame = 0
					$Stand.set_value(1)
				7:
					dash_base_speed = -4000
					dash_break_acceleration = 500	
					woosh_sound(true)	
				8:
					dash_base_speed = 0
					dash_break_acceleration = 0
					check_collision("red_stand_kicks")	
							
				11:
					dash_base_speed = -4000
					dash_break_acceleration = 500	
					woosh_sound(true)	
				12:
					dash_base_speed = 0
					dash_break_acceleration = 0
					check_collision("red_stand_kicks")
					
				15:
					dash_base_speed = -4000
					dash_break_acceleration = 500	
					woosh_sound(true)	
				16:
					dash_base_speed = 0
					dash_break_acceleration = 0
					check_collision("red_stand_kicks")
					emit_aura("red", false)
					
					
				
		"quick_unblockable":
			match frame:
				2:
					dash_base_speed = -200
					dash_break_acceleration = 0
				3:
					$Stand.play("jab_yellow")
					$Stand.frame = 0
					$Stand.set_value(1)
					woosh_sound(false)	
					Global.emit_signal("generic_attack", false)
				4:
					dash_base_speed = 0
					dash_break_acceleration = 0
					check_collision("quick_unblockable")
				
				
				
	
				

				
				
				
					
				
				
				
				
				
				
				
				
func emit_aura(color, boolean):
	if boolean:
		match color:
			"blue":
				$CPUParticles2D.change_emit(true, Color(0.18,0.62,1,1))
			"red":
				$CPUParticles2D.change_emit(true, Color(1,0,0.16,1))	
			"yellow":
				$CPUParticles2D.change_emit(true, Color(0.94,1,0.27,1))
			
			
	else:
		$CPUParticles2D.change_emit(false, null)
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
					
				
		
		
func red_kick():
	set_state("reversing", "the attacks1")
	$AnimatedSprite.play("red_kick")
	emit_aura("red", true)
		
func blue_attack():
	set_state("reversing", "the attacks2")
	$AnimatedSprite.play("blue_attack")
	emit_aura("blue", true)
	
func white_attack():
	set_state("attacking", "the attacks3")
	$AnimatedSprite.play("white_punch")	
	
func dash_empty():
	set_state("attacking", "the attacks4")
	$AnimatedSprite.play("dash_empty")
	
func dash_attack():
	set_state("attacking", "the attacks5")
	$AnimatedSprite.play("dash_attack")
	
func white_kicks():
	set_state("attacking", "the attacks6")
	$AnimatedSprite.play("white_kicks")
	
func reversal(): #not on animation
	set_state("attacking", "the attacks7")
	$AnimatedSprite.play("reversal")
	
func slow_unblockable():
	set_state("attacking", "the attacks8")
	$AnimatedSprite.play("slow_unblockable")
	
func block_punishable():
	set_state("attacking", "the attacks9")
	$AnimatedSprite.play("block_punishable")
	
func short_unblockable():
	set_state("reversing", "the attacks91")
	$AnimatedSprite.play("short_unblockable")
	emit_aura("yellow", true)

func jump_attack():
	set_state("attacking", "the attacks92")
	$AnimatedSprite.play("jump_attack")
	
func block_punishable2():
	set_state("attacking", "the attacks93")
	$AnimatedSprite.play("block_punishable2")
	
func red_stand_kicks():
	set_state("reversing", "the attacks94")
	$AnimatedSprite.play("red_stand_kicks")

func quick_unblockable():#not on animation
	if not State == "hit_stun":
		set_state("attacking", "the attacks95")
		$AnimatedSprite.play("quick_unblockable")
		

	
	
	
	
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				

var red_kick_connects = false

func _on_red_kick_body_entered(body):
	if body.name == "GoodPlayer":
		red_kick_connects = true
func _on_red_kick_body_exited(body):
	if body.name == "GoodPlayer":
		red_kick_connects = false





var white_punch_connects = false

func _on_white_punch_body_entered(body):
	if body.name == "GoodPlayer":
		white_punch_connects = true
func _on_white_punch_body_exited(body):
	if body.name == "GoodPlayer":
		white_punch_connects = false





var blue_attack_connects = false

func _on_blue_attack_body_entered(body):
	if body.name == "GoodPlayer":
		blue_attack_connects = true
func _on_blue_attack_body_exited(body):
	if body.name == "GoodPlayer":
		blue_attack_connects = false





var dash_attack_connects = false

func _on_dash_attack_body_entered(body):
	if body.name == "GoodPlayer":
		dash_attack_connects = true
func _on_dash_attack_body_exited(body):
	if body.name == "GoodPlayer":
		dash_attack_connects = false
		
		
		
		
		
var white_kicks_connects = false

func _on_white_kicks_body_entered(body):
	if body.name == "GoodPlayer":
		white_kicks_connects = true
func _on_white_kicks_body_exited(body):
	if body.name == "GoodPlayer":
		white_kicks_connects = false




var reversal_connects = false

func _on_reversal_body_entered(body):
	if body.name == "GoodPlayer":
		reversal_connects = true
func _on_reversal_body_exited(body):
	if body.name == "GoodPlayer":
		reversal_connects = false




var slow_unblockable_connects = false

func _on_slow_unblockable_body_entered(body):
	if body.name == "GoodPlayer":
		slow_unblockable_connects = true
func _on_slow_unblockable_body_exited(body):
	if body.name == "GoodPlayer":
		slow_unblockable_connects = false




var block_punishable_connects = false

func _on_block_punishable_body_entered(body):
	if body.name == "GoodPlayer":
		block_punishable_connects = true
func _on_block_punishable_body_exited(body):
	if body.name == "GoodPlayer":
		block_punishable_connects = false




var short_unblockable_connects = false

func _on_short_unblockable_body_entered(body):
	if body.name == "GoodPlayer":
		short_unblockable_connects = true
func _on_short_unblockable_body_exited(body):
	if body.name == "GoodPlayer":
		short_unblockable_connects = false





var jump_attack_connects = false

func _on_jump_attack_body_entered(body):
	if body.name == "GoodPlayer":
		jump_attack_connects = true
func _on_jump_attack_body_exited(body):
	if body.name == "GoodPlayer":
		jump_attack_connects = false
		
		
		
		

var block_punishable2_connects = false

func _on_block_punishable2_body_entered(body):
	if body.name == "GoodPlayer":
		block_punishable2_connects = true
func _on_block_punishable2_body_exited(body):
	if body.name == "GoodPlayer":
		block_punishable2_connects = false






var red_stand_kicks_connects = false

func _on_red_stand_kicks_body_entered(body):
	if body.name == "GoodPlayer":
		red_stand_kicks_connects = true
func _on_red_stand_kicks_body_exited(body):
	if body.name == "GoodPlayer":
		red_stand_kicks_connects = false














var slow_attack_connect = false





const HIT_PARTICLE = preload("res://second platformer character controller/HitEffect.tscn")
const BLOCK_PARTICLE = preload("res://second platformer character controller/BlockEffect.tscn")
const REVERSAL_PARTICLE = preload("res://second platformer character controller/ReversalEffect.tscn")

func spawn_effect(name):
	var temp_effect = null
	match name:
		"block":
			temp_effect = BLOCK_PARTICLE.instance()
			Global.emit_signal("large_light", global_position, Color(1,1,1,1), 3, 0.6, 0.1, 0.5) #(position, color, size, power, start_time, end_time)
		"hit":
			temp_effect = HIT_PARTICLE.instance()
		"reversal":
			temp_effect = REVERSAL_PARTICLE.instance()
			Global.emit_signal("large_light", global_position, Color(1,1,1,1), 6, 0.9, 0.03, 0.4) #(position, color, size, power, start_time, end_time)
	
	
	
	temp_effect.position.y -= 10
	temp_effect.position.x -= 5
	temp_effect.amount = 200
	temp_effect.scale = Vector2(-1.5,1.5)
	temp_effect.gravity = -temp_effect.gravity
	
	temp_effect.global_position = global_position
	get_parent().add_child(temp_effect)












func _on_AnimationPlayer_animation_finished(anim_name):
	timer_counter += level

