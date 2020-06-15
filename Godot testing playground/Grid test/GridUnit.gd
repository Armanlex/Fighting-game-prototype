extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var super_grid = []

var grid_location = Vector2(0,0)
var desired_loc = Vector2.ZERO

var counter = 0

var post_move_delay_bool = true
var post_move_delay = 2
var post_move_delay_counter = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	
	super_grid = get_parent().super_grid



# Called every frame. 'delta' is the elapsed time since the previous frame.



func _input(event):
	
	
	
	var where_to = grid_location
	
	if post_move_delay_bool:
		if Input.is_action_just_pressed("camera_up"):
			where_to = check_tile(grid_location, Vector2(0,-1))
		
		elif Input.is_action_just_pressed("camera_down"):
			where_to = check_tile(grid_location, Vector2(0,1))
	
		elif Input.is_action_just_pressed("camera_left"):
			where_to = check_tile(grid_location, Vector2(-1,0))
	
		elif Input.is_action_just_pressed("camera_right"):
			where_to = check_tile(grid_location, Vector2(1,0))
	
		

	grid_location = where_to

	#print("grid location: ",grid_location)

	get_node("Tween").stop(self, "global_position")
	get_node("Tween").interpolate_property(self, "global_position", global_position, desired_loc, 0.01)
	get_node("Tween").start()





 

func check_tile(hex_pos, direction):
	post_move_delay_counter = 0
	if post_move_delay_bool:
		post_move_delay_bool = false
		
		var super_grid = get_parent().super_grid
		hex_pos += direction
		
		if is_numb_in_range_of_grid(hex_pos):		
			if super_grid[hex_pos.y][hex_pos.x][1] == true:
				
				if not direction.y == 0:
					if direction.y > 0:
						if int(hex_pos.y-direction.y)%2 == 0:
							
							if is_numb_in_range_of_grid(hex_pos+ Vector2(1,0)):
								if not super_grid[hex_pos.y][hex_pos.x+1][1] == true:
									
									super_grid[hex_pos.y][hex_pos.x+1][1] = true
									super_grid[hex_pos.y-direction.y][hex_pos.x-direction.x][1] = false
									return hex_pos + Vector2(1,0)
								else:
									return hex_pos - direction
							else:
								return hex_pos - direction

						else:
							if is_numb_in_range_of_grid(hex_pos - Vector2(1,0)):
								if not super_grid[hex_pos.y][hex_pos.x-1][1] == true:
									
									super_grid[hex_pos.y][hex_pos.x-1][1] = true
									super_grid[hex_pos.y-direction.y][hex_pos.x-direction.x][1] = false
									return hex_pos - Vector2(1,0)
								else:
									return hex_pos - direction
							else:
									return hex_pos - direction
							
							
							
					else:
						if int(hex_pos.y-direction.y)%2 == 0:
							
							if is_numb_in_range_of_grid(hex_pos+ Vector2(1,0)):
								if not super_grid[hex_pos.y][hex_pos.x+1][1] == true:
									
									super_grid[hex_pos.y][hex_pos.x+1][1] = true
									super_grid[hex_pos.y-direction.y][hex_pos.x-direction.x][1] = false
									return hex_pos + Vector2(1,0)
								else:
									return hex_pos - direction
							else:
								return hex_pos - direction
						else:
							
							if is_numb_in_range_of_grid(hex_pos- Vector2(1,0)):
								if not super_grid[hex_pos.y][hex_pos.x-1][1] == true:
									
									super_grid[hex_pos.y][hex_pos.x-1][1] = true
									super_grid[hex_pos.y-direction.y][hex_pos.x-direction.x][1] = false
									return hex_pos - Vector2(1,0)
								else:
									return hex_pos - direction
							else:
								return hex_pos - direction
								
							
						
				return hex_pos - direction
					
			else:
				super_grid[hex_pos.y][hex_pos.x][1] = true
				super_grid[hex_pos.y-direction.y][hex_pos.x-direction.x][1] = false
				return hex_pos
		else:
			return hex_pos - direction
		
	



func is_numb_in_range_of_grid(hex_pos):
	if hex_pos.x >= 0 and hex_pos.y >= 0 and hex_pos.x <= super_grid.size()-1 and hex_pos.y <= super_grid.size()-1:
		return true
	else:
		false



func _process(delta):
	if post_move_delay_counter < post_move_delay:
		post_move_delay_counter += 1
		post_move_delay_bool = false
	else:
		post_move_delay_bool = true
		pass
		
	
	
	desired_loc = get_parent().pos_processed(grid_location+Vector2(1,1))
	
	
