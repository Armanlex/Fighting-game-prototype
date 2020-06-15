extends Node2D










var direction = Vector2.ZERO
 
var velocity = 350





func _ready():
	$CPUParticles2D.direction = direction
	$CPUParticles2D.emitting = true
	$CPUParticles2D.initial_velocity = velocity
	
	
	
func _process(delta):
	if $CPUParticles2D.emitting == false:
		queue_free()
	

