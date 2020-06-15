extends Node2D

#var CLICK_HERE = 2


var spectrum = AudioServer.get_bus_effect_instance(0, 0) #(which buss? 0 since it's the only one, which effect? 0 cause it's the only one)




var z = 149

var linear = 0
var max_frequency = 22000
var spectrum_list = []
var spectrum_list2 = []
var new_value
var timer = 0



func _ready():

	$AudioStreamPlayer.play()
	
	

	z = 200
	for i in z:
		spectrum_list.append(0)
		spectrum_list2.append(0)
		

	for i in 200:
		print((i*i*i)/360)
	
	
	






func _process(delta):

	for i in z:
		
		var ii = i + 1
		linear = spectrum.get_magnitude_for_frequency_range((i*i*i)/360,((ii*ii*ii)/360))*1000
		
		if i < 20:
			pass
		else:
			
			new_value = ((linear.length()) * ( 1 + ((i*i) / 170) ))
			
			if spectrum_list[i] < new_value*0.9:
				spectrum_list[i] = (new_value + spectrum_list[i]*2)/3
			else:
				spectrum_list[i] = (new_value + spectrum_list[i]*15.0)/16
			
		

		
	update()
	get_node("Anchor").spectrum_list = spectrum_list
	
	
	
	
	
func _draw():
	for i in spectrum_list.size():
		var x = i*3
		var y = spectrum_list[i]
		draw_line(Vector2(x,0), Vector2(x,-y), Color(1,1,1,1), 1.5, false)
		
