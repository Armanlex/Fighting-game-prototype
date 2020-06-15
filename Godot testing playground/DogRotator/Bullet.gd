extends KinematicBody2D


var target_pos = null

var current_direction = Vector2(1,0)
var desired_direction = Vector2.ZERO

const SPEED = 200
var speed = 200
var acceleration_first = 300
var acceleration_second = 0

var slow_state = true

var turn_rate = 20

var homing = true

var life_span = 130






func _ready():
	pass
	
	



func _physics_process(delta):
	
	if acceleration_first > 0:
		acceleration_first -= 0.9 + acceleration_first/11.0
	
	
	if slow_state == false and turn_rate < 300:
		turn_rate += 3
		
		
	if acceleration_second < 1200 and slow_state == false:
		acceleration_second = 7 + (acceleration_second*1.05)
		
			
		
	
	speed = SPEED + acceleration_second + acceleration_first
	
	if target_pos != null:
		desired_direction = target_pos - global_position
		
		if homing:
			var angle = current_direction.angle_to(desired_direction)
			var min_ang = 0.02
			if angle < min_ang and angle > -min_ang:
				angle = 0
			current_direction = current_direction.rotated(angle*(deg2rad(turn_rate/10.0)))
		else:
			current_direction = desired_direction
	
	
	current_direction = move_and_slide(current_direction.normalized() * speed)
	
	
	#VISUALS:
	
	$Sprite.scale.x = 0.3 * (1.0+speed/800.0)
	
	if homing:
		$Sprite.look_at(current_direction*10)
	else:
		$Sprite.look_at(target_pos)
	
	
	life_span -= 1
	
	if life_span < 90:
		slow_state = false
		
	if life_span < 70:
		homing = false
	
	if life_span < 0:
		queue_free()
		
	
	
	
	
func die():
	queue_free()
	Global.emit_signal("bullet_died")
	return [current_direction, speed/3]
