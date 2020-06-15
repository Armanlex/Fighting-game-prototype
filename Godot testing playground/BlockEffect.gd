extends CPUParticles2D











func _ready():
	emitting = true
	one_shot = true
	



var timer = 60
var counter = 0

func _process(delta):
	counter += 1
	if counter > timer:
		queue_free()
		
	
