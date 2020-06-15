extends Node2D

var goto_original = true

var pure_vector = Vector2(0,0)
var unpure_vector = Vector2(0,0)

var pure_vector_x_hat = Vector2(1.0,0.0)
var old_pure_vector_x_hat = Vector2(1.0,0.0)

var pure_vector_y_hat = Vector2(0.0,1.0)
var old_pure_vector_y_hat = Vector2(0.0,1.0)

var accept_pressed = false
var x = 0

var list = {}


func draw_the_line():
	unpure_vector = pure_vector.x * pure_vector_x_hat + pure_vector.y * pure_vector_y_hat
	unpure_vector = unpure_vector.rotated(x)
		
	draw_circle(unpure_vector, 3, Color(0.7,0.5,0.5,0.4))
	
	
	
	
	
func show_matrix():
	get_parent().get_node("Camera2D/hats").text = str("X hat: ",pure_vector_x_hat, " Y haat: ", pure_vector_y_hat)

	print("This is in armanlex branch only") #not anymore, no


	print(pure_vector_x_hat.x," ",pure_vector_y_hat.x)
	print(pure_vector_x_hat.y," ",pure_vector_y_hat.y)
	





func _draw():
	
	var x = 2 # method selector
	
	for i in 33: # creates the basis of the dictionary used to compile the rng data
		list[i-16] = 0
	
	
	if x == 1: # equal distribution
		for i in 1000:
			list[randi()%32 - 16] += 1
		
	
	elif x == 2: # bell like curve
		for i in 1000:
			var variance = 0
			for i in 8:
				variance += randi()%5 - 2	
			list[variance] += 1
	
	
	elif x == 3:
		for i in 1000:
			#======================================== from -16 to 16
			var random_number = 0			
			
			
			
			#========================================
			list[random_number] += 1










	for i in 32: #draws the graph based on the dictionary with the compiled data
		for x in list[i-16]:
			pure_vector = Vector2((i*10)+10,(x*3)+10)
			draw_the_line()






















func _process(delta):
	var zoom = get_parent().get_node("Camera2D").zoom.x / 100

	if Input.is_action_pressed("ui_page_up"):
		update()
		get_parent().get_node("Camera2D").zoom	-= Vector2(zoom,-zoom)
		print(get_parent().get_node("Camera2D").zoom)
		
	if Input.is_action_pressed("ui_page_down"):
		update()
		
		get_parent().get_node("Camera2D").zoom	+= Vector2(zoom,-zoom)
		print(get_parent().get_node("Camera2D").zoom)

		
	if Input.is_action_pressed("camera_down"):
		get_parent().get_node("Camera2D").position.y += zoom*300
		
	if Input.is_action_pressed("camera_up"):
		get_parent().get_node("Camera2D").position.y -= zoom*300
		
	if Input.is_action_pressed("camera_left"):
		get_parent().get_node("Camera2D").position.x += zoom*300
		
	if Input.is_action_pressed("camera_right"):
		get_parent().get_node("Camera2D").position.x -= zoom*300
		
	
	if Input.is_action_pressed("ui_left"):
		pure_vector_x_hat -= Vector2(0.1,0.0)
		show_matrix()
		update()
		

		
	if Input.is_action_pressed("ui_right"):
		pure_vector_x_hat += Vector2(0.1,0.0)
		show_matrix()
		update()

		
	if Input.is_action_pressed("ui_up"):
		pure_vector_x_hat += Vector2(0.0,0.1)
		show_matrix()
		update()

		
	if Input.is_action_pressed("ui_down"):
		pure_vector_x_hat -= Vector2(0.0,0.1)	
		show_matrix()	
		update()

#=================================================

	if Input.is_action_pressed("ui_left_second"):
		pure_vector_y_hat -= Vector2(0.1,0.0)
		show_matrix()
		update()

		
	if Input.is_action_pressed("ui_right_second"):
		pure_vector_y_hat += Vector2(0.1,0.0)
		show_matrix()
		update()

		
	if Input.is_action_pressed("ui_up_second"):
		pure_vector_y_hat += Vector2(0.0,0.1)
		show_matrix()
		update()

		
	if Input.is_action_pressed("ui_down_second"):
		pure_vector_y_hat -= Vector2(0.0,0.1)	
		show_matrix()	
		update()
	
	
	if Input.is_action_just_pressed("tween"):
		
		if goto_original:
			
			goto_original = false
			$Tween.interpolate_property(self, "pure_vector_x_hat",null, Vector2(1,0),1)
			$Tween.start()
			$Tween.interpolate_property(self, "pure_vector_y_hat",null, Vector2(0,1),1)
			$Tween.start()
			old_pure_vector_x_hat = pure_vector_x_hat
			old_pure_vector_y_hat = pure_vector_y_hat
		else:
			goto_original = true
			$Tween.interpolate_property(self, "pure_vector_x_hat",null, old_pure_vector_x_hat,1)
			$Tween.start()
			$Tween.interpolate_property(self, "pure_vector_y_hat",null, old_pure_vector_y_hat,1)
			$Tween.start()
			
			
			
		
	
		


func _ready():
	show_matrix()
	update()
	

	
	



func _on_Tween_tween_step(object, key, elapsed, value):
	update()
	pass # Replace with function body.
