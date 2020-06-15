extends Node2D


const OBJECT = preload("res://OneObject.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for i in 1000:
		var object = OBJECT.instance()
		object.global_position = Vector2( (randi()%20)+500, (randi()%20)+300)
		add_child(object)
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
