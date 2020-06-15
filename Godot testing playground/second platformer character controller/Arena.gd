extends Node2D

var timer = 70
var timer_counter = 0

const ATTACK = preload("res://second platformer character controller/RandomAttack.tscn")
const DUMMY = preload("res://second platformer character controller/AudioDummy.tscn")
const LARGE_LIGHT = preload("res://second platformer character controller/FarLight.tscn")	


var begin_game_timer = 20


func _ready():
	dir_contents("res://.import/")
	

	
	
	spawn_audio_dummy("dio_theme.ogg", 1, -20, "code")
	Global.connect("block_sound", self, "block_sound")
	Global.connect("hit_sound", self, "hit_sound")
	Global.connect("counter_sound", self, "counter_sound")
	Global.connect("woosh", self, "woosh_sound")
	
	Global.connect("appear", self, "appear")
	Global.connect("disappear", self, "disappear")
	Global.connect("humm", self, "humm")
	Global.connect("flame", self, "flame_sound")
	
	Global.connect("hahaha", self, "hahaha_sound")
	Global.connect("hehehe", self, "hehehe_sound")
	Global.connect("muda", self, "muda_sound")
	Global.connect("mudada", self, "mudada_sound")
	Global.connect("generic_attack", self, "generic_attack_sound")
	Global.connect("generic_hurt", self, "generic_hurt_sound")
	Global.connect("baddy_dead", self, "baddy_dead_sound")
	Global.connect("resurrect", self, "resurrect_sound")
	Global.connect("narukami", self, "narukami_sound")
	Global.connect("shock", self, "shock_sound")
	Global.connect("killu_hurt", self, "killu_hurt_sound")
	Global.connect("play_sound", self, "play_sound_test")
	Global.connect("pause",self,"mini_pause")
	Global.connect("shake",self,"shake_camera")
	Global.connect("large_light",self,"spawn_large_light")
	



var loaded_sound_files = {}

var sound_files_list = []

func dir_contents(path):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				#print("Found directory: " + file_name)
				pass
			else:
				#print("Found file: " + file_name)
				
				#if file_name.ends_with(".wav") or file_name.ends_with(".ogg"):
				if file_name.ends_with(".sample") or file_name.ends_with(".oggstr"):
					sound_files_list.append(file_name)
					var file_name_normal = file_name.split("-",true,1) #rsplit(delimiter: String, allow_empty: bool = true, maxsplit: int = 0)
					loaded_sound_files[file_name_normal[0]] = load(str(path, file_name))
				
			file_name = dir.get_next()
		#print(sound_files_list)
			
	else:
		print("An error occurred when trying to access the path.")
		
		
		



func play_sound_test(name, pitch, vol):
	var file_name = str(name,".wav")
	spawn_audio_dummy(file_name, pitch, vol, "empty")






func spawn_audio_dummy(file_name, pitch, vol, code):
	var dummy = DUMMY.instance()
	#file_name = str(file_name)
	#dummy.stream = load(file_name)
	dummy.stream = loaded_sound_files[file_name]
	dummy.pitch_scale = pitch
	dummy.volume_db = vol
	
	match code: #-15.1 is humm
		"baddy_voice": Global.connect("baddy_shut_up", dummy, "_on_AudioDummy_finished")
		"stand_humm": Global.connect("humm_stop", dummy, "_on_AudioDummy_finished")
		"particle_effect": Global.connect("flame_stop", dummy, "smooth_stop")
	
	add_child(dummy)
	




func generic_attack_sound(is_big):
	Global.emit_signal("baddy_shut_up")
	var temp_num = ((randi()%20)-10.0)/250.0
	if is_big:
		match randi()%2:
			0:spawn_audio_dummy("1shout1.wav", 1+temp_num, -21, "baddy_voice")
			1:spawn_audio_dummy("1hmmM.wav", 1+temp_num, -18, "baddy_voice")
	else:
		match randi()%3:
			1:spawn_audio_dummy("1shout2.wav", 1+temp_num, -21, "baddy_voice")
			0:spawn_audio_dummy("1shout3.wav", 1+temp_num, -21, "baddy_voice")
			2:spawn_audio_dummy("1hmm.wav", 1+temp_num, -19, "baddy_voice")



func generic_hurt_sound(is_big):
	Global.emit_signal("baddy_shut_up")
	var temp_num = ((randi()%20)-10.0)/250.0
	if is_big:
		spawn_audio_dummy("1cry4.wav", 1+temp_num, -21, "baddy_voice")
	else:
		match randi()%2:
			1:spawn_audio_dummy("1cry5.wav", 1+temp_num, -21, "baddy_voice")
			0:spawn_audio_dummy("1cry6.wav", 1+temp_num, -21, "baddy_voice")
	



func mudada_sound():
	Global.emit_signal("baddy_shut_up")
	spawn_audio_dummy("1mudada.wav", 1, -15, "baddy_voice")

func muda_sound():
	Global.emit_signal("baddy_shut_up")
	spawn_audio_dummy("1muda.wav", 1, -15, "baddy_voice")

func hahaha_sound():
	Global.emit_signal("baddy_shut_up")
	spawn_audio_dummy("1hahaha.wav", 1, -15, "baddy_voice")
	

func hehehe_sound():
	Global.emit_signal("baddy_shut_up")
	spawn_audio_dummy("hehehe.wav", 1, -19, "baddy_voice")


func baddy_dead_sound():
	Global.emit_signal("baddy_shut_up")
	spawn_audio_dummy("1dead.wav", 1, -19, "baddy_voice")
	

func resurrect_sound():
	Global.emit_signal("baddy_shut_up")
	match randi()%5:
		0:spawn_audio_dummy("1sentense.wav", 1, -19, "baddy_voice")
		1:spawn_audio_dummy("1sentense2.wav", 1, -19, "baddy_voice")
		2:spawn_audio_dummy("1sentense3.wav", 1, -19, "baddy_voice")
		3:spawn_audio_dummy("1sentense4.wav", 1, -19, "baddy_voice")
		4:spawn_audio_dummy("1sentense5.wav", 1, -19, "baddy_voice")
	







func appear():
	spawn_audio_dummy("appear.wav", 1, -28, "empty")
	
func disappear():
	spawn_audio_dummy("disappear.wav", 1, -28, "empty")
	
func humm():
	spawn_audio_dummy("humm.wav", 1, -26.1, "stand_humm")






func flame_sound():
	spawn_audio_dummy("flame.wav", 2, -16.11, "particle_effect")


func hit_sound(is_big):
	if is_big:
		#get_node("hit_big").play()
		spawn_audio_dummy("strong_hit.wav", 1, 5.7, "empty")
	else:
		#get_node("hit").play()
		spawn_audio_dummy("normal_hit2.wav", 1, 3, "empty")



	
func block_sound():
	#get_node("block").play()
	spawn_audio_dummy("block.wav", 1, -4, "empty")

	
	
	
func counter_sound():
	#get_node("counter").play()
	spawn_audio_dummy("counter.wav", 1, 0, "empty")
	
	
	
	
func woosh_sound(is_big):
	var speed_scale = 2
	if is_big:
		speed_scale = 1.3

	#get_node("woosh").pitch_scale = speed_scale
	spawn_audio_dummy("woosh3.wav", speed_scale, -14, "empty")
	#get_node("woosh").play()





func narukami_sound():
	spawn_audio_dummy("2narukami.wav", 1.03, -8.11, "empty")
	
	
	
	
	
	
func shock_sound():
	spawn_audio_dummy("1shock.wav", 1.03, -20.11, "empty")



func killu_hurt_sound():
	match randi()%2:
		0:spawn_audio_dummy("2hurt2.wav", 1, -10.11, "empty")
		1:spawn_audio_dummy("2hurt3.wav", 1, -10.11, "empty")
	


var pause_timer = 0
var pause_timer_counter = 0

func mini_pause(frames):
	get_tree().paused = true
	pause_timer = frames
	pause_timer_counter = pause_timer
	$Tween.interpolate_property(get_node("Camera2D/RealCamera2D"),"pause_zoom",0.97,1,0.1,Tween.TRANS_SINE)
	$Tween.start()
	
func mini_pause_system():
	if pause_timer_counter > 0:
		pause_timer_counter -= 1
	else:
		get_tree().paused = false
	




func shake_camera(is_big):
	get_node("Camera2D/RealCamera2D/CameraShake").stop(true)
	if is_big:
		get_node("Camera2D/RealCamera2D/CameraShake").play("big")
	else:
		get_node("Camera2D/RealCamera2D/CameraShake").play("small")


func _physics_process(delta):
	if begin_game_timer > 0:
		begin_game_timer -= 1
	elif begin_game_timer == 0:
		begin_game_timer -= 1
		Global.emit_signal("start_match")
		
	
	$CanvasLayer/baddy_level.text = str("ROUND: ",$BadPlayer.level+1)
	#timer_counter += 1
	if timer_counter > timer:
		spawn_attack()
		timer_counter = 0
		
		
		
	mini_pause_system()
	if Input.is_action_just_pressed("ui_page_down"):
		get_node("Camera2D/RealCamera2D/CameraShake").stop(true)
		get_node("Camera2D/RealCamera2D/CameraShake").play("big")
	
	
	
	
	
	if get_node("GoodPlayer").State == "dead":
	
		$CanvasLayer/restart_button.visible = true
		if Input.is_action_just_pressed("tween"):
			get_tree().change_scene("res://second platformer character controller/Arena.tscn")
	elif get_node("BadPlayer").State == "dead" and get_node("BadPlayer").level == 5:
		$CanvasLayer/you_win.visible = true
		if Input.is_action_just_pressed("tween"):
			get_tree().change_scene("res://second platformer character controller/Arena.tscn")
	
	
	
	
func spawn_large_light(position, color, size, power, start_time, end_time):
	
	match color:
		"white": color = Color(1,0.6,0.2,1)
		"blue": color = Color(0,0.3,1,1) 
		"red": color = Color(1,0.3,0,1)
		"yellow": color = Color(0.8,1,0.1,1)
	
	
	var light = LARGE_LIGHT.instance()
	light.power = power
	light.color = color 
	light.texture_scale = size 
	light.end_time = end_time
	light.start_time = start_time
	add_child(light)
	light.global_position = position 
	


func spawn_attack():
	var attack = ATTACK.instance()
	attack.global_position = Vector2(900,500)
	add_child(attack)
