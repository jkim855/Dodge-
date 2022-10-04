extends Node2D

var menu_lock = false
var pressed = false
onready var slide = get_node("Animations/AnimationPlayer")
onready var Move_Cam = $Animations/Move_Cam
onready var Fade_In = $Animations/Fade_In
onready var Move = $Animations/Move
onready var Line = $Sprites/Line
onready var Level = load("res://src/Level.tscn").instance()
onready var Cover = get_node("Cover")
onready var Menu = get_node("Menu")
onready var Store = get_node("Popup/Store")
var store_pressed = false
var watched
onready var info_window = get_node("Shop/popups/info_popup")

func _ready():
#	Global.tutorial = true
#	Global.data["next_alert"] = null
	$Update.visible = false
#	Global.data["next_alert"] = 24
	if Global.data["next_alert"] == null:
		set_next_alert()

	else:
		if OS.get_date()["month"] > Global.data["next_alert"]["month"] or (OS.get_date()["day"] >= Global.data["next_alert"]["day"] and OS.get_date()["month"] >= Global.data["next_alert"]["month"]):
			$Update.visible = true

			set_process_input(false)
			set_next_alert()
			
	$press.visible = false
	if Global.data["watched"]:
		watched = (OS.get_date().hash() == Global.data["watched"].hash())
	
	$Money.visible = false
	$Settings.visible = false
	if Global.Start_Tutorial:
		Menu.visible = false
		$Reward.visible = false
	if Global.tutorial:
		Global.Start_Tutorial = false
		Global.save_data()
		$Play.set_block_signals(true)
		$Reward.set_block_signals(true)
		$Money/charge.set_block_signals(true)
		Menu.visible = true
		flash(Menu)
		get_node("../tutorial").set_block_signals(true)
	elif !watched:
		flash($Reward)
	particle_off()
	$Popup.visible = false
	$Shop.visible = false
#	get_node("AnimationPlayer").queue("Jump")
	Line.modulate.a = 0
	slide.play("Slide")

#	$Particles.position = $Sprite.position

func set_next_alert():
	var date = OS.get_date()
	var day = date["day"] + 7
	
	if OS.get_date()["month"] == 2:
		if day > 28:
			day -= 28
			date["month"] += 1
	else:
		if day > 30:
			day -= 30
			date["month"] += 1
	date["day"] = day
	Global.data["next_alert"] = date
	Global.save_data()

func revert_button(sprite):
	sprite.modulate = Color(1, 1, 1)
	sprite.z_index = 0

func flash(sprite):
	sprite.z_index = 1
	var down = true
	sprite.modulate = Color(1.2, 1.2, 0.45)
	while true:
		
		if sprite.is_pressed():
			
			if sprite == Menu:
				revert_button(sprite)
				menu_lock = true
#				Menu.set_block_signals(true)
				get_node("Popup/Settings").set_block_signals(true)
				flash(Store)
				break
		elif sprite == Store and store_pressed:
			menu_lock = false
			$Money.visible = true
			Menu.set_block_signals(false)
			get_node("Popup/Settings").set_block_signals(false)
			revert_button(sprite)
			get_node("Menu").set_block_signals(true)
			$Money/charge.set_block_signals(false)
#			$window.nextPhrase()
			Cover.visible = false
			$Reward.set_block_signals(false)
			
			flash($Reward)
			
			
			break
		if down:
			sprite.modulate.a -= 0.01
		else:
			sprite.modulate.a += 0.01
		if sprite.modulate.a >= 1.05:
			down = true
		elif sprite.modulate.a <= 1:
			down = false
		yield(get_tree().create_timer(0.1), "timeout")

func _input(event):
	#test
#	if Input.is_action_just_pressed("float"):
#		Global.test_room = true
#		Global.testing = true
#		get_tree().change_scene("res://src/Video_Level.tscn")
	
	if Input.is_action_just_pressed("Enter"):
		Global.Start_Tutorial = false
		Global.tutorial = true
		get_tree().reload_current_scene()
#		get_parent().play()
		
#	if Input.is_action_just_pressed("jump"):
#		slide.stop()
#		slide.play("Jump")

	if !pressed and !$Play.is_pressed() and !$Menu.is_pressed() and event is InputEventScreenTouch and event.is_pressed():
#		Transition.main()
		pressed = true
		$press.visible = false
		$Timer.stop()
		
		
		Move_Cam.play("Down")
		yield(Move_Cam, "animation_finished")
		
		if Global.tutorial:
			Cover.visible = true
		if !Global.Start_Tutorial:
			$Money.visible = true
#	elif pressed and !$Popup/Background.is_pressed() and !$Play.is_pressed() and !$Menu.is_pressed() and event is InputEventScreenTouch and event.is_pressed():
#		pressed = false
#		Move_Cam.play_backwards("Down")
#		$Money.visible = true
		
func _on_AnimationPlayer_animation_finished(_anim_name):
#	print("end")	
	pass
		
func _on_Fade_In_animation_finished(_anim_name):
#	$Laser.animate()
#	$AnimationPlayer.play("Jump")
	$Jump.set_wait_time(2)

func fade_in():
	Fade_In.play("Fade_In")

func move_floor():
	Move.play("Move")

func particle_off():
	$Particles.emitting = false
	
func particle_on():
	$Particles.emitting = true

func _on_Jump_timeout():
	slide.play("Jump")


#func _on_Play_pressed():
#	Global.test = false
#	Global.testing = false
#	if get_tree().change_scene("res://src/Level.tscn") != OK:
#		print("Error during [Change Scene]")

func fall():

	$Animations/Fall.play("Fall")

func move_line():
	$Animations/Move_Line.play("Move_Line")

#func _on_Play_released():
#	$Play.visible = false
#	$Menu.visible = false
#	$Jump.stop()
#	if $Animations/AnimationPlayer.playback_active:
#		print("1")
#		if $Animations/AnimationPlayer.current_animation_position < 0.8:
#			yield($Animations/AnimationPlayer, "animation_finished")
#
#		yield(get_tree().create_timer(1), "timeout")
#		print("3")
#	$Animations/Move.get_animation("Move").loop = false
#	yield($Animations/Move, "animation_finished")
#
#	$Animations/Move.play("Move_out")
#
#	yield($Animations/Fall, "animation_finished")
##	yield(get_tree().create_timer(0.5), "timeout")
#	Global.test = false
#	Global.testing = false
#
##	if get_tree().change_scene("res://src/Level.tscn") != OK:
##		print("Error during [Change Scene]")
#	add_child(Level)
#	var main = self
#	Level.queue_free()


func _on_Menu_pressed():
	if !$Popup.visible:
		$Popup.visible = true
	else:
		if !menu_lock:
			$Popup.visible = false
	$Reward_Popup.visible = false

func _on_Settings_pressed():
#	get_tree().change_scene("res://src/Settings.tscn")
	$Settings.visible = true
	$Popup.visible = false
	$Menu.visible = false
	$Back.visible = true
	$Play.visible = false
	$Reward.visible = false

func _on_Store_pressed():
	
	$Play.visible = false
	$Shop.visible = true
	$Shop/popups/skins_window.visible = true
	$Shop/buttons.visible = true
	$Popup.visible = false
	$Back.visible = true
	$Menu.visible = false
	store_pressed = true

	$Shop.change_button()
	$Reward.visible = false
	$Money/Money.text = str(Global.data["money"])
#	$Shop/popups/window.visible = true

func _on_Back_pressed():
	$Reward_Popup.godot_count = 0
	if Global.tutorial and !($Shop/popups/info_popup.visible or $Shop/popups/charge_window.visible):
		$Money/charge.set_block_signals(true)
		Cover.visible = true
#		flash($Reward)
	if info_window.visible:
		info_window.visible = false
		$Shop/buttons/skins_button.set_block_signals(false)
		$Shop/buttons/ability_button.set_block_signals(false)
		$Shop/buttons/items_button.set_block_signals(false)
		$Money/charge.set_block_signals(false)
		$Shop.touchable = true
		$Shop/popups/items_window.touchable = true
		return
	
	if $Shop/popups/charge_window.visible:
		$Shop/popups/charge_window.visible = false
		
		if $Shop.popup_temp != $Settings:
			$Shop/buttons.visible = true
		if !$Shop.popup_temp:
			$Shop.visible = false
			$Back.visible = false
			$Play.visible = true
			$Reward.visible = true
			$Menu.set_block_signals(true)
			button_cool($Menu)
			if $Reward_Popup.visible:
				
				$Play.visible = false
				$Back.visible = true
			return
		$Shop.popup_temp.visible = true
		if $Shop.popup_temp != $Shop/popups/skins_window:
			$Shop/popups/window.visible = true
		return
	else:
		$Shop.popup_temp = null
	if $Shop/popups/ability_window.visible:
		$Shop.hide_popups()
	
	
	if $Reward_Popup/credits_window.visible:
		$Reward_Popup/page/ad.set_block_signals(false)
		$Reward_Popup/credits_window.visible = false
		$Reward_Popup/page.visible = true
		$Reward.visible = true
		$Money.visible = true
		$Back.set_block_signals(true)
		button_cool($Back)
		return
	$Shop.visible = false
	$Settings.visible = false
	for popup in $Shop/popups.get_children():
		popup.visible = false
#	$Popup.visible = true
	$Play.visible = true
	$Back.visible = false
	$Menu.visible = true
	$Reward.visible = true
	
	$Reward_Popup/credits_window.visible = false
	$Reward_Popup.visible = false
	$Menu.set_block_signals(true)
	button_cool($Menu)
	$Reward_Popup/verif.visible = false
	get_node("Shop").revert_skin()
#	$Money.visible = false

func button_cool(button):
	yield(get_tree().create_timer(0.1), "timeout")
	button.set_block_signals(false)

func _on_skins_button_pressed():
	pass # Replace with function body.


func _on_backgrounds_button_pressed():
	pass # Replace with function body.


func _on_left_arrow_pressed():
	pass # Replace with function body.


func _on_right_arrow_pressed():
	pass # Replace with function body.


func _on_confirm_pressed():
	pass # Replace with function body.


func _on_purchase_pressed():
	pass # Replace with function body.


func _on_bg_left_pressed():
	pass # Replace with function body.


func _on_bg_right_pressed():
	pass # Replace with function body.


func _on_Test_pressed():
	if get_tree().change_scene("res://src/Test.tscn") != OK:
		print("Error during [Change Scene]")



#func _on_hack3_pressed():
#	if Global.data["watched"]:
#		Global.data["watched"]["day"] += 1

func load_reward():
	get_node("AdMob").load_rewarded_video()

func show_reward():
	get_node("AdMob").show_rewarded_video()


func _on_Timer_timeout():
	$press.visible = true


#func _on_Move_Cam_animation_finished(anim_name):
#	if anim_name == "down":
#		$Money.visible = true


func _on_link_pressed():
	OS.shell_open("https://www.youtube.com/watch?v=afwK743PL2Y&ab_channel=Waterflame")


func _on_link2_pressed():
	OS.shell_open("https://www.youtube.com/watch?v=0oH9zS6Lufw")

func _on_link3_pressed():
	OS.shell_open("https://freeiconshop.com")


func _on_link4_pressed():
	OS.shell_open("https://www.youtube.com/watch?v=KxwUy2S2n-Q")


func _on_link5_pressed():
	OS.shell_open("https://www.youtube.com/watch?v=mrgVpZhjOWk&ab_channel=NoCopyrightMusic")


func _on_update_pressed():
	OS.shell_open("https://play.google.com/store/apps/details?id=dodge.pw")
	$Update.visible = false
	set_process_input(true)


func _on_no_pressed():
	$Update.visible = false
	set_process_input(true)
