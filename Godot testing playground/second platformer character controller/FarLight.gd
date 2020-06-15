extends Light2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var power = 0
var start_time = 0
var end_time = 0

var var_energy = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#print("large light spawned!")
	$Tween.interpolate_property(get_node("."), "var_energy", null, power, start_time, Tween.TRANS_SINE)
	$Tween.start()
	
func _physics_process(delta):
	energy = var_energy
	
	#print(position," - ",  color," - ",  texture_scale," - ",  var_energy,"-",power,"-",energy," - ",  start_time," - ",  end_time)
	



func _on_Tween_tween_completed(object, key):
	if var_energy == power:
		$Tween.interpolate_property(self, "var_energy", null, 0, end_time,Tween.TRANS_LINEAR)
		$Tween.start()
		
	else:
		#print("large light says bye bye!")
		queue_free()
