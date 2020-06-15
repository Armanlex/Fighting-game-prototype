extends AudioStreamPlayer






var smooth_stop = false
var file = null



func _ready():
	#print("I'm ALIIIIIIIVE")
	

	
	play()
	
	
	
	
func _on_AudioDummy_finished():
	queue_free()

	

	
	
func _physics_process(delta):
	if smooth_stop:
		volume_db -= 0.2

		if volume_db < 50:

			queue_free()
	
	
	
	
func smooth_stop():
	smooth_stop = true
	
	
