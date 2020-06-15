extends Node2D


var speed = -10

var color = "white"



func _ready():
	randomize()
	
	var ran_num = randi()%3
	match ran_num:
		0:
			color = "white"
			$white.visible = true
		1:
			color = "red"
			$red.visible = true
		2:
			color = "blue"
			$blue.visible = true
	





func _process(delta):
	position.x -= speed
	speed += 1
	





func _on_Area2D_body_entered(body):
	
	var block_stun = (randi()%10)+8
	var hit_stun = (randi()%15)+15
	var ch_stun = (randi()%40)+20
	var pushback = -((randi()%60)+30)
	
	if body.name == "GoodPlayer":
		body.attack_received(0, 0, false,color, block_stun, hit_stun, ch_stun, pushback)
		queue_free()
	
