extends Node2D

onready var Intro = get_node("../Intro/Reward_Popup")

func _ready():
	$AdMob.load_rewarded_video()

func _on_AdMob_rewarded(_currency, _ammount):
	Intro.reward()


func _on_AdMob_rewarded_video_closed():
	$AdMob.load_rewarded_video()


