extends Node2D

#onready var admob = get_node("../AdMob")
onready var credits = $credits_window
onready var verif = $verif
onready var page = $page
onready var money_board = get_node("../Money")
onready var money = get_node("../Money/Money")
var godot_count = 0
#var admob

func _ready():
	visible = false
	credits.visible = false
	verif.visible = false
#	$AdMob.load_rewarded_video()
#	admob.load_rewarded_video()
	
	
	$page/Test.visible = false
	$page/Test2.visible = false
	$page/Test3.visible = false
	$page/Test4.visible = false
#	MobileAds.connect("rewarded", self, "reward")
#	MobileAds.connect("initialization_complete", self, "_on_initialization_complete")
	


#func _on_initialization_complete(status, adapter_name):
#	if status==MobileAds.INITIALIZATION_STATUS.READY:
#		MobileAds.load_rewarded()

#func load_video():
#	admob.load_rewarded_video()
#
#func show_video():
#	admob.show_rewarded_video()

func _on_Reward_pressed():
	if Global.tutorial:
		get_node("../Play").set_block_signals(false)
		get_node("../Menu").set_block_signals(false)
		get_node("../Money/charge").set_block_signals(false)
		Global.tutorial = false
		get_node("../Cover").visible = false
		Global.save_data()
	if Global.data["watched"] and OS.get_date().hash() == Global.data["watched"].hash():
		change_page()
	visible = true
	page.visible = true
#	if Global.data["multiplier"]:
#		get_node("page/to_earn").text = "1000"
#		get_node("page/to_earn").rect_position.x -= 15
#		get_node("page/money").position.x -= 15
	get_node("../Popup").visible = false
	get_node("../Back").visible = true
	get_node("../Play").visible = false
	get_node("../Menu").visible = false
	money_board.visible = true
	money.text = str(Global.data["money"])
	
func _on_ad_pressed():
#	print("hi")
#	admob.show_rewarded_video()
#	reward()
	if Global.data["admin"]:
		reward()
		return
	get_node("../../Ad/AdMob").show_rewarded_video()

func reward():
	Global.data["watched"] = OS.get_date()
#	Global.save_data()
#	$page/Test4.visible = true

	get_parent().revert_button(get_node("../Reward"))
	get_node("../Reward").visible = false
	
	
	Global.data["money"] += 350
#	if Global.data["multiplier"]:
#		Global.data["money"] += 500
#		get_node("verif/earned").text = "1000"
#		get_node("verif/earned").rect_position.x -= 15
#		get_node("verif/money2").position.x -= 15	
	money.text = str(Global.data["money"])
	Global.save_data()
	page.visible = false
	verif.visible = true

func _on_AdMob_rewarded(_currency, _ammount):
#	$page/Test3.visible = true
	reward()
#	pass

func _on_credits_pressed():
	$page/ad.set_block_signals(true)
	get_node("../Reward").visible = false
	credits.visible = true
	money_board.visible = false
	get_node("../Back").visible = true

func change_page():
	$page/money.visible = false
	$page/Label.visible = false
	$page/to_earn.visible = false
	$page/ad.visible = false
	$page/Label3.visible = true


#func _on_AdMob_rewarded_video_loaded():
#	$page/Test.visible = true
#
#
#func _on_AdMob_rewarded_video_opened():
#	$page/Test2.visible = true


func _on_godot_pressed():
	if Global.data["admin"]:
		get_tree().change_scene("res://src/Test.tscn")
	if godot_count == 2:
		get_tree().change_scene("res://src/password.tscn")
	godot_count += 1
