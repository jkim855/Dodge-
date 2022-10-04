extends Node2D

onready var GameOver = get_parent()

func _ready():
	$AdMob.load_rewarded_video()

func _on_AdMob_rewarded(_currency, _ammount):
	GameOver.reward()


func _on_AdMob_rewarded_video_closed():
	$AdMob.load_rewarded_video()

#func _physics_process(delta):
#	if Input.is_action_just_pressed("float"):
#		GameOver.reward()
