extends ProgressBar









func _ready():
	Global.connect("baddy_got_hit",self,"baddy_got_hit")



func baddy_got_hit():
	value -= 1

