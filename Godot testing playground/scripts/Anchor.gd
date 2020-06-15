extends Node2D

#var CLICK_HERE = 2




var spectrum_list = []
var final_value = 0
var total_counter = 0



var x_start = 0
var x_stop = 0
var y_start = 0
var y_stop = 0

var timer = 0


func _ready():
	pass


func _draw():
	draw_line($BottomLeft.position,Vector2(x_start,y_stop),Color.white,1,false)
	draw_line($BottomLeft.position,Vector2(x_stop,y_start),Color.white,1,false)
	draw_line($TopRight.position,Vector2(x_stop,y_start),Color.white,1,false)
	draw_line($TopRight.position,Vector2(x_start,y_stop),Color.white,1,false)


func test(hello: String, pokemon: bool, karate: float):
	print(hello)

func _process(delta):

	x_start = $BottomLeft.position.x
	x_stop = $TopRight.position.x
	y_start = $BottomLeft.position.y
	y_stop = $TopRight.position.y
	update()
	
	

	
#	timer += 1
#
#	if timer % 100 == 0:
	
	var yay = false
#	print("list start")
	for i in spectrum_list.size():
		if i > int(x_start/3) and i < int(x_stop/3):
#			print("inside x")
			if spectrum_list[i] > int(-y_start) and spectrum_list[i] < int(-y_stop):
#				print("inside y")
				yay = true
#			else:
#				print("spectrum_list[i]: ", spectrum_list[i], " y_start: ",-y_start," y_stop: ",-y_stop)
					
	if yay == true:
		$Dancer.rotation_degrees += 1
		if $Dancer.rotation_degrees > 360:
			$Dancer.rotation_degrees -= 360

				

		
	
	
	
	
	

#print("CLICK_HERE: ", CLICK_HERE)
#get_tree().get_root().get_node("TopNode/SecondNode")
