extends Node2D

onready var resume_timer = $Resume_Timer
onready var second = 3
onready var bgm = get_node("../Music")
var bgm_pos
onready var Pause = get_node("../Touch_Buttons/Controls/Pause")

func _ready():
	visible = false
	$CanvasLayer.get_child(0).visible = false
	$CanvasLayer.get_child(1).visible = false
	for child in $Buttons.get_children():
		child.visible = false

func pause():
	get_node("../Background2").paused = true
#	get_node("../Touch_Buttons/Joypad/Joystick").ongoing_drag = -1
	Global.move_vector = Vector2.ZERO
	get_tree().paused = true
	bgm_pos = bgm.get_playback_position()
	bgm.stop()
	
	#Comment out for screenshot
	visible = true
	$CanvasLayer.get_child(0).visible = true
	
	get_node("../CanvasLayer/Score").visible = false
	
#	for i in get_node("../Touch_Buttons/Controls").get_children():
#		i.visible = false
#	get_node("../Touch_Buttons/Health").visible = false
	
	get_node("../Touch_Buttons").visible = false
	
	for child in $Buttons.get_children():
		child.visible = true

func _process(_delta):
#	if Input.is_action_just_pressed("Esc"):
		#pause()
		
	if is_visible() and Input.is_action_just_pressed("Enter"):
#	if Input.is_action_just_pressed("Enter"):
#		count_down(3)

		$CanvasLayer/Countdown.visible = true
		$CanvasLayer/Countdown.text = str(second)
		resume_timer.connect("timeout", self, "count_down")
		resume_timer.start()
		
		self.visible = false
	
		$CanvasLayer.get_child(0).visible = false
		
#		for i in get_node("../Touch_Buttons").get_children():
#			i.visible = true
		get_node("../Touch_Buttons").visible = true
		
func count_down():
	if second > 1:
		second -= 1
		$CanvasLayer/Countdown.text = str(second)
		
	else:
		second = 3
		resume_timer.stop()
		$CanvasLayer/Countdown.visible = false
		resume()

func resume():
	
	get_node("../Background2").paused = false
	Pause.set_block_signals(false)
	get_tree().paused = false
	get_node("../CanvasLayer/Score").visible = true
	bgm.play()
	bgm.seek(bgm_pos)

func _on_Exit_pressed():
	Global.boosted = false
	get_tree().paused = false
	get_tree().change_scene("res://src/Intro.tscn")	
	MusicController.get_child(0).play()
	Global.laser_pattern = true
	Global.square_pattern = false
#func _on_Resume_pressed():
#	get_tree().paused = false
#	self.hide()
	

#
#func count_down(second):
#	print(second, " to ", second-1)
#	$CanvasLayer/Countdown.text = str(second)
#	if second > 0:
##		print(resume_timer.is_stopped())
#		resume_timer.stop()
#		resume_timer.connect("timeout", self, "count_down", [second-1])
#		resume_timer.start()
##		print(resume_timer.is_stopped())
#
#	else:
#		resume_timer.connect("timeout", self, "resume")
#		resume_timer.start()


func _on_Resume_pressed():
#	get_node("../Touch_Buttons/Health").visible = true
	$CanvasLayer/Countdown.visible = true
	$CanvasLayer/Countdown.text = str(second)
	resume_timer.connect("timeout", self, "count_down")
	resume_timer.start()
	
	self.visible = false

	$CanvasLayer.get_child(0).visible = false
	
#	for i in get_node("../Touch_Buttons/Controls").get_children():
#		i.visible = true
	get_node("../Touch_Buttons").visible = true
#	get_node("../Touch_Buttons")
	
	for child in $Buttons.get_children():
		child.visible = false
	
	get_node("../CanvasLayer/Score").visible = true


func _on_Pause_pressed():
	pause()
	Pause.set_block_signals(true)
