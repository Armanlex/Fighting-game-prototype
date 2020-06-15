extends ProgressBar


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("player_got_hit",self,"change_value")
	pass # Replace with function body.


func change_value():
	value -= 1
