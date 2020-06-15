extends KinematicBody2D

var BULLET = preload("res://DogRotator/Bullet.tscn")

var desired_vector = Vector2(-1,0)
var desired_rotation = 0


var x = 0
var desired_direction = Vector2.ZERO


func _ready():
	randomize()
	get_parent().get_node("Dog").connect("new_rotation", self, "signal_new_rotation")
#	get_node(".").connect("new_rotation", self, "signal_new_rotation")

func _process(delta):
	look_at(desired_direction)
	
	
	



func signal_new_rotation(vector):
	desired_direction = vector
	
	for i in 5:
		spawn_bullet(vector)


func spawn_bullet(target):
	var bullet = BULLET.instance()
	
	bullet.global_position = global_position	
	bullet.target_pos = target
	bullet.current_direction = target.rotated(deg2rad( (randi()%1000)-500 ))
	
	get_parent().add_child(bullet)
	
