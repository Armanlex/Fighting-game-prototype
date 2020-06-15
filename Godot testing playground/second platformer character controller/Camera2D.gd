extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var pause_zoom = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):

	var zoomy = abs(get_parent().get_parent().get_node("BadPlayer").global_position.x - get_parent().get_parent().get_node("GoodPlayer").global_position.x)

	zoomy = 1+ max(0, zoomy-550) /1000.0



	zoom.x = (zoom.x*10 + zoomy)/11.0
	zoom.y = (zoom.y*10 + zoomy)/11.0
	
	zoom *= pause_zoom
