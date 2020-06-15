extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var new_x_pos = (get_parent().get_node("BadPlayer").global_position.x + get_parent().get_node("GoodPlayer").global_position.x)/2.0

	
	global_position.x = (global_position.x*3.0 + new_x_pos)/4.0
	


