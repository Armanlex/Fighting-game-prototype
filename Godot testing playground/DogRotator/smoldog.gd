extends Sprite

const BLAST = preload("res://DogRotator/ParticleBlast.tscn")









func _ready():
	Global.connect("bullet_died", self, "bullet_died") 
	


func bullet_died():
	$AnimationPlayer.play("hit")
	pass
	




func _on_Area2D_body_entered(body):
	
	var bullet_info = body.die()
	
	var blast = BLAST.instance()
	#blast.global_position = global_position
	blast.direction = bullet_info[0]
	blast.velocity = bullet_info[1]
	
	add_child(blast)
	











