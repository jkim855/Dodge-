extends Node2D

onready var resume_timer = $Resume_Timer
onready var second = 10
#onready var admob = get_node("../../Intro/AdMob")
#onready var Intro = get_node("../../Intro")
#onready var Ad = get_node("../../Ad/AdMob")
onready var Revive_Ad = get_node("../../ReviveAd/AdMob")
onready var Revive_Ad_Test = get_node("../../ReviveAd")
var children
onready var bgm = get_node("../Music")
var bgm_pos
var revived = 0
var Revive_Ad2
var Revive_Ad_Scene

func _ready():
	hide_popup()
	
#	admob.load_rewarded_video()
	if !Global.testing:
		if !Revive_Ad:
			Revive_Ad_Scene = load("res://src/Revive_Ad.tscn").instance()
			add_child(Revive_Ad_Scene)
			Revive_Ad = get_node("ReviveAd/AdMob")
		Revive_Ad.load_rewarded_video()
#	Ad.load_rewarded_video()
	set_process_input(false)
	set_physics_process(false)
	
#func _input(event):
	#keeps receving some input, is almost a physics_process function
#	if event is InputEventScreenTouch and event.is_pressed():
#		if !get_node("../Revive").is_pressed():
#			die()
#	pass

#func _physics_process(delta):
#	if Input.is_action_just_pressed("Enter"):
#		Transition.replay()
#	if Input.is_action_just_pressed("float"):
#		resume()
#	if Input.is_action_just_pressed("die"):
#		get_parent().die()
#
#		set_physics_process(false)

func show_give_up():
	yield(get_tree().create_timer(2.5), "timeout")
	$give_up.visible = true

func show_popup():
#	$die.play()
	visible = true
	get_node("../Revive").visible = true
	get_node("../heart").visible = true
	get_node("AnimationPlayer").play("heart")
	#test
	show_give_up()
	set_physics_process(true)
	
	
	bgm_pos = bgm.get_playback_position()
	bgm.stop()
	get_node("../Touch_Buttons/Joypad/Joystick").ongoing_drag = -1
	Global.move_vector = Vector2.ZERO
	get_tree().paused = true
	
#	popup()
#	$Timer.start()
	
#	get_node("../Score").visible = false
#	children = get_node("../Touch_Buttons").get_children()
#	children.pop_back()
#	for i in children:
#		i.visible = false
	get_node("../Touch_Buttons").visible = false
#	if is_visible() and Input.is_action_just_pressed("Enter"):
		
	$Countdown.visible = true
	$Countdown.text = str(second)
	resume_timer.connect("timeout", self, "count_down")
	resume_timer.start()
	
	

#	for child in get_children():
#		child.visible = true
	
	$give_up.visible = false
			
func count_down():
	if second > 1:
		second -= 1
		$Countdown.text = str(second)
		
	else:
		die()

func resume():
	revived += 1
	if revived == 1:
		Revive_Ad.queue_free()
		var Revive_Ad_Scene2 = load("res://src/Revive_Ad2.tscn").instance()
		add_child(Revive_Ad_Scene2)
		Revive_Ad2 = get_node("ReviveAd2/AdMob")
		Revive_Ad2.load_rewarded_video()

	get_node("../Touch_Buttons/Health/Timer").stop()
	get_node("../Touch_Buttons/Health").set_inv_on_resume()
	
#	print(revived)
	set_process_input(false)
	for child in get_node("../pattern_objects").get_children():
		child.queue_free()
	for child in get_node("../Background2/random_laser").get_children():
		child.queue_free()
		
#	if Global.spin_pattern:
#		get_node("../Background2/Laser").resume = true
#		get_node("../Background2/Laser").stop()
#		yield(get_tree().create_timer(0.5), "timeout")
#		get_node("../Background2/Laser").start()
#		get_node("../Background2/Laser").resume = false
	get_tree().paused = false
	self.visible = false
	hide_popup()
	
	get_node("../Touch_Buttons").visible = true
#	for i in children:
#		i.visible = true
		
	second = 10
	resume_timer.stop()
	$Countdown.visible = false
	get_parent().get_node("Touch_Buttons/Health").set_lives()
	bgm.play()
	bgm.seek(bgm_pos)

func _on_Revive_pressed():
#	print("hi")
	set_process_input(false)
	if Global.data["no_ads"]:
		resume()
		return
#	Intro.show_reward()
#	admob.show_rewarded_video()
	if revived < 1:
		Revive_Ad.show_rewarded_video()
	else:
		Revive_Ad2.show_rewarded_video()

#func _on_AdMob_rewarded(currency, ammount):
#	resume()

func die():
	set_process_input(false)
	second = 10
	resume_timer.stop()
	$Countdown.visible = false
#	self.visible = false
	hide_popup()
	get_parent().die()

func hide_popup():
	visible = false
	get_node("../Revive").visible = false
	get_node("../heart").visible = false
	set_physics_process(false)
#	for child in get_children():
#		child.visible = false



#func _on_Timer_timeout():
#	if !revived:
#		set_process_input(true)




#func _on_AdMob_rewarded(currency, ammount):
#	resume()


func _on_give_up_pressed():
	die()

