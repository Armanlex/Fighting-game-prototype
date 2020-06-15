extends Node2D






var super_grid = []
var h_grid = [] # pos, T/F = is unit on that position
var total_offset = Vector2(130,25)


var x = 1
var y = 0
var s = 30
var pos_x_mul = s*0.9
var pos_y_mul = s*1.57



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	for i in 11:
		
		for x in 11:
			
			var booly = false
			if randi()%4 == 0:
				booly = true
				
			
			if i%2 == 0:
				if x == 11:
					break
				h_grid.append([Vector2(x+1, i+1), booly])
			else:
				h_grid.append([Vector2(x+1, i+1), booly])
			
		super_grid.append(h_grid)
		h_grid = []
		
	update()
			
	
	


func _draw():
	for i in super_grid.size():
		for x in super_grid[i].size():
			
			var pos = super_grid[i][x][0]
						
			pos = pos_processed(pos)
			
			var pool_array = create_hex_pool(pos)
			
			if super_grid[i][x][1]:
				draw_colored_polygon(pool_array, Color(0.8,0.3,0.3,0.8))
			else:
				draw_colored_polygon(pool_array, Color(1,1,1,0.5))
			
			
				
func create_hex_pool(pos):	
	var pool_array = PoolVector2Array([])
	for i in 6:
		pool_array.append( (Vector2(x*s,y*s).rotated(deg2rad(60*i))).rotated(deg2rad(30)) + pos)		
	return pool_array
	
	
	

	
func pos_processed(pos):
	if not int(pos.y)%2 == 0:
		pos.x += 0.5
	pos.x = pos.x*2
	pos.x = pos.x*pos_x_mul + total_offset.x
	pos.y = pos.y*pos_y_mul + total_offset.y
	return pos




func _process(delta):
	
	if Input.is_action_pressed("ui_left"):
		pos_x_mul -= 1
		
	if Input.is_action_pressed("ui_right"):
		pos_x_mul += 1
		
	if Input.is_action_pressed("ui_down"):
		pos_y_mul += 1
		
	if Input.is_action_pressed("ui_up"):
		pos_y_mul -= 1
		
	#print("x: ", pos_x_mul, " y: ", pos_y_mul)
	update()
		
		
