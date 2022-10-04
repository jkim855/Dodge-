extends Node2D

var multiply = 1
onready var Double_Ad_Scene = load("res://src/Double_Ad.tscn").instance()
var Double_Ad
var money_added
var rewarded = false
var score = Global.score

func _ready():
	$EndScreen/boost.visible = false
	$EndScreen/Double_Window/give_up.visible = false
#	$EndScreen/Double_Window/Money3.visible = true
	$EndScreen/Double_Window.visible = false
	add_child(Double_Ad_Scene)
	Double_Ad = Double_Ad_Scene.get_child(0)
	Double_Ad.load_rewarded_video()
	
	$EndScreen/doubled.visible = false
	$EndScreen/Money.text = ""
	$EndScreen/Exit.visible = false
	$EndScreen/Restart.visible = false
#	$EndScreen/ad.modulate.a = 0
#	$EndScreen/result1.modulate.a = 0
#	$EndScreen/result2.modulate.a = 0
#	$EndScreen/double.visible = false
#	$EndScreen/Money2.modulate.a = 0
#	$EndScreen/Sprite2.modulate.a = 0
	$EndScreen/High_Score.modulate.a = 0
	$EndScreen/High_Score_Label.modulate.a = 0
	$EndScreen/Money.modulate.a = 0
	$EndScreen/Sprite.modulate.a = 0
	
	$EndScreen/multiplier.modulate.a = 0
	$EndScreen/ad_multiplier.modulate.a = 0
	money_added = round(Global.score)
	if Global.boosted:
		money_added -= Global.boosted
		
#	get_node("EndScreen/Money").text = str(money_added)
	if Global.data["multiplier"]:
#		$EndScreen/multiplier.visible = true
		multiply = 2	
		hide_double()
		
#		$EndScreen/double.visible = false
#		$EndScreen/Sprite2.visible = false
#		$EndScreen/result1.visible = false
#		$EndScreen/result2.visible = false
#		$EndScreen/ad.visible = false
#		$EndScreen/Money2.visible = false
		rewarded = true
		
	money_added *= multiply
#	print(money_added)
	Global.data["money"] += money_added
	Global.save_data()
	get_node("EndScreen/Money").text = str(money_added)

#func _physics_process(delta):
##	if $Restart.is_pressed():
#	if Input.is_action_pressed("Enter"):
#		Transition.replay()
#		Global.laser_pattern = true
#		Global.square_pattern = false

func _on_Exit_pressed():
#	Transition.replay()
	MusicController.get_child(0).play()
	get_tree().paused = false
	Transition.get_child(0).get_child(0).modulate = 0
	get_tree().change_scene("res://src/Intro.tscn")


func _on_ad_pressed():
#	reward()
	if !rewarded:
		Double_Ad.show_rewarded_video()

func reward():
	if !rewarded:
		$EndScreen/doubled.visible = true
		Global.data["money"] += money_added
		Global.save_data()
		get_node("EndScreen/Money").text = str(money_added*2)
		rewarded = true
		$EndScreen/Money.modulate.a = 1.4
		money_modulate()
#		$EndScreen/ad_multiplier.visible = true
#		if !$EndScreen/multiplier.visible:
#			$EndScreen/ad_multiplier.position = Vector2(766, 417)

func hide_double():
	$EndScreen/Double_Window.visible = false
	$EndScreen/Exit.visible = true
	$EndScreen/Restart.visible = true
#	$EndScreen/double.visible = false
#	$EndScreen/Sprite2.visible = false
#	$EndScreen/result1.visible = false
#	$EndScreen/result2.visible = false
#	$EndScreen/ad.visible = false
#	$EndScreen/Money2.visible = false

func money_modulate():
	hide_double()
	
	while $EndScreen/Money.modulate.a >= 1:
		$EndScreen/Money.modulate.a -= 0.05
		yield(get_tree().create_timer(0.05), "timeout")

func _on_test_pressed():
	reward()

func fade_money():
	while $EndScreen/Money.modulate.a < 1:
		$EndScreen/Money.modulate.a += 0.05
		$EndScreen/Sprite.modulate.a += 0.05
		yield(get_tree().create_timer(0.07), "timeout")
	calc_money()
	if Global.data["multiplier"]:
		$EndScreen/doubled.visible = true
	if Global.boosted:
		$EndScreen/boost.visible = true
	Global.boosted = null
func calc_money():
#	score = 170.21
#	$EndScreen/Money.text = str(score)
#	money_added = round(score)
	
	$EndScreen/Double_Window/Money2.text = str(money_added*2)

	if money_added <= score: #round down
		round_down()
	elif money_added > score: #round up
		round_up()
	
	
	
func fade_double():
	if !rewarded:
		$EndScreen/Double_Window.visible = true
#		$EndScreen/double.visible = true
#		$EndScreen/Sprite2.modulate.a = 1
#		$EndScreen/result1.modulate.a = 1
#		$EndScreen/result2.modulate.a = 1
#		$EndScreen/ad.modulate.a = 1
#		$EndScreen/Money2.modulate.a = 1
		animate_ad()
		yield(get_tree().create_timer(2), "timeout")
		$EndScreen/Double_Window/give_up.visible = true
	else:
		$EndScreen/doubled.visible = true
		
#	$EndScreen/Exit.visible = true
#	$EndScreen/Restart.visible = true

func animate_ad():
	
	$AnimationPlayer.play("bubble")
#	var up = true
#	while true:
#		if $EndScreen/ad.scale <= Vector2(0.19, 0.19):
#			up = true
#		elif $EndScreen/ad.scale >= Vector2(0.25, 0.25):
#			up = false
#		if up:
#			$EndScreen/ad.scale += Vector2(0.01, 0.01)
#		else:
#			$EndScreen/ad.scale -= Vector2(0.01, 0.01)
#		yield(get_tree().create_timer(0.1), "timeout")	
		
func round_down():
#	while score > money_added:
#		score -= 0.01
#		$EndScreen/Money.text = str(score)
#		yield(get_tree().create_timer(0.1), "timeout")
#	print(money_added)
	$EndScreen/Money.text = str(money_added)
#	$EndScreen/Double_Window/Money3.text = str(money_added)
#	$EndScreen/Double_Window/Money3.visible = true
#	$EndScreen/Double_Window/Money3.text = str(money_added)
	yield(get_tree().create_timer(1.1), "timeout")
	fade_double()
func round_up():
#	while score < money_added:
#		score += 0.01
#		$EndScreen/Money.text = str(score)
#		yield(get_tree().create_timer(0.1), "timeout")
#	print(money_added)
	$EndScreen/Money.text = str(money_added)
#	$EndScreen/Double_Window/Money3.text = str(money_added)
	yield(get_tree().create_timer(1.1), "timeout")
	fade_double()


func _on_Restart_pressed():
#	print("money: ", Global.data["money"])
	Transition.replay()
#	print("money: ", Global.data["money"])


func _on_give_up_pressed():
	$EndScreen/Double_Window.visible = false
	$EndScreen/Exit.visible = true
	$EndScreen/Restart.visible = true
