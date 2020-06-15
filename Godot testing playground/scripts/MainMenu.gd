extends Node2D

var show_controls = false
var control_type_selected = "pc"

func _ready():
	pass



func _physics_process(delta):
	$PcControls.visible = false
	$PsControls.visible = false
	$XboxControls.visible = false
	$TldrGuide.visible = false
	$empty.visible = false
	$Close.visible = false
	if show_controls:
		$TldrGuide.visible = true
		$empty.visible = true
		$Close.visible = true
		match control_type_selected:
			"pc":
				$PcControls.visible = true
			"ps":
				$PsControls.visible = true
			"xbox":
				$XboxControls.visible = true
			

	



func _on_AudioVisualizer_pressed():
	get_tree().change_scene("res://ActualAudioVisualizer.tscn")
	pass # Replace with function body.


func _on_DogRotation_pressed():
	get_tree().change_scene("res://DogRotator/DogRotator.tscn")
	pass # Replace with function body.


func _on_GraphVisualizer_pressed():
	get_tree().change_scene("res://Graph visualizer.tscn")
	pass # Replace with function body.


func _on_PlatformWithCollision_pressed():
	get_tree().change_scene("res://PlatformWithCollisions.tscn")
	pass # Replace with function body.


func _on_Hexagonal_Grid_pressed():
	get_tree().change_scene("res://Grid test/Grid.tscn")
	pass # Replace with function body.


func _on_gon_game_button_down():
	get_tree().change_scene("res://Platformer Controller/Arena.tscn")
	pass # Replace with function body.


func _on_2d_tekken_fighter_pressed():
	get_tree().change_scene("res://second platformer character controller/Arena.tscn")
	pass # Replace with function body.




func _on_Close_pressed():
	show_controls = false



func _on_Playstation_pressed():
	show_controls = true
	control_type_selected = "ps"


func _on_pcbutton_pressed():
	show_controls = true
	control_type_selected = "pc"


func _on_xboxbutton_pressed():
	show_controls = true
	control_type_selected = "xbox"
