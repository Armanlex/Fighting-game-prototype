extends Spatial

var ziel_koordinaten = [Vector3(5,5,5), Vector3(-5,-5,-5), Vector3(5,5,5), Vector3(-5,-5,-5)]
var ziel_index = 1

func _ready():
	$Ziel/BewegungsTreen.interpolate_property($Ziel, 
											"translation", 
											$Ziel.translation,
											ziel_koordinaten[ziel_index], 
											0.2, 
											Tween.TRANS_LINEAR,
											Tween.EASE_IN_OUT)
	$Ziel/BewegungsTreen.start()
	

func _process(delta):
	
	# aktuelle rotation
	var a = Quat($Dreh_mich.transform.basis)
	# zielposition
	var po = $Ziel.transform.origin
	# y fixen
	po.y = $Dreh_mich.transform.origin.y
	
	# Zielrotation ermitteln
	var b = Quat($Dreh_mich.transform.looking_at(po, Vector3.UP).basis)
	
	# Zwischenpunkt in richtung Zielrotation finden
	var c = a.slerp(b, 0.05)
	# Zum Zwischenpunkt drehen
	$Dreh_mich.transform.basis = Basis(c)
	
	
	# zum Ziel drehen
	#$Dreh_mich.look_at($Ziel.global_transform.origin, Vector3(0,1,0))




func _on_BewegungsTreen_tween_all_completed():
	ziel_index +=1
	if ziel_index > 3:
		ziel_index = 0
		$Ziel/BewegungsTreen.interpolate_property($Ziel, 
											"translation", 
											$Ziel.translation,
											ziel_koordinaten[ziel_index], 
											3, 
											Tween.TRANS_LINEAR,
											Tween.EASE_IN_OUT)
	else:
		$Ziel/BewegungsTreen.interpolate_property($Ziel, 
												"translation", 
												$Ziel.translation,
												ziel_koordinaten[ziel_index], 
												0.2, 
												Tween.TRANS_LINEAR,
												Tween.EASE_IN_OUT)
	$Ziel/BewegungsTreen.start()
