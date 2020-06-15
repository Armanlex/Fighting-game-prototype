extends PathFollow2D






var speed = 2







func _ready():
	pass






func _process(delta):
	
	speed = max((50/(global_position - get_parent().get_parent().get_node("KinematicDog").global_position).length()),0.1)
	
	offset += speed
	
