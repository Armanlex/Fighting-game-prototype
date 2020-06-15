extends Light2D



var value_a = 0
var power = 0.9






func _process(delta):
	energy = (energy*5.0 + (value_a * power))/6.0

