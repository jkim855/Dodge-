extends Node2D

var Death_Popup

func _ready():
	$AdMob.load_rewarded_video()

func _on_AdMob_rewarded(_currency, _ammount):
	Death_Popup = get_node("../Level/Death_Popup")
	Death_Popup.resume()

#Test revival
#func _physics_process(delta):
#	if Input.is_action_just_pressed("Enter"):
#		Death_Popup = get_node("../Level/Death_Popup")
#		Death_Popup.resume()	

