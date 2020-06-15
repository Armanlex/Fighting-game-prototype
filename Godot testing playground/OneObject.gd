extends RigidBody2D



var velocity = Vector2.ZERO

func _ready():
	randomize()
	velocity.x = (randi()%10)-5
	velocity.y = (randi()%10)-5
	velocity = velocity.normalized() * 5



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y += 10
	
