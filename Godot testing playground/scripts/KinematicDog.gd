extends KinematicBody2D









var leader_pos = Vector2.ZERO
var desired_vector = Vector2.ZERO

var leader = null
var speed = 5

func _ready():
	leader = get_parent().get_node("Path2D/PathFollow2D/Leader")


func _process(delta):
	
	leader_pos = leader.global_position
	
	desired_vector = (leader_pos - global_position)*speed
	
	
	move_and_slide(desired_vector)
	
	
