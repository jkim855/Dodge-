extends Node2D

var Tutorial = "res://src/Tutorial.tscn"
var Dialogue = "res://src/Dialogue.tscn"
var payment
var reset_count = 0

var prev_settings = {
	"level":{
		"laser" : true,
		"square" : true,
		"moving" : true,
		"spin" : true,
		"max_speed" : false
	}
}

func _ready():
	update_button_display()

func _on_Back_pressed():
	get_tree().change_scene("res://src/Intro.tscn")
	set_values()

func _input(event):
	if Input.is_action_just_pressed("Enter"):
		get_tree().change_scene("res://src/Video.tscn")

func set_values():
	Global._settings["level"]["laser"] = $Canvas/Laser.pressed
	Global._settings["level"]["square"] = $Canvas/Square.pressed
	Global._settings["level"]["moving"] = $Canvas/Moving.pressed
	Global._settings["level"]["spin"] = $Canvas/Spin.pressed
	Global._settings["level"]["max_speed"] = $Canvas/Max.pressed
	Global.save_settings()
	
func _on_Play_pressed():
	set_values()
	Global.testing = true
	get_tree().change_scene("res://src/Level.tscn")
#	get_tree().change_scene("res://src/Intro.tscn")

func _on_Reset_pressed():
	prev_settings["level"]["laser"] = $Canvas/Laser.pressed
	prev_settings["level"]["square"] = $Canvas/Square.pressed
	prev_settings["level"]["moving"] = $Canvas/Moving.pressed
	prev_settings["level"]["spin"] = $Canvas/Spin.pressed
	prev_settings["level"]["max_speed"] = $Canvas/Max.pressed
	Global._settings["level"]["laser"] = true
	Global._settings["level"]["square"] = true
	Global._settings["level"]["moving"] = true
	Global._settings["level"]["spin"] = true
	Global._settings["level"]["max_speed"] = false
	update_button_display()


func _on_Restore_pressed():
	Global._settings["level"]["laser"] = prev_settings["level"]["laser"]
	Global._settings["level"]["square"] = prev_settings["level"]["square"]
	Global._settings["level"]["moving"] = prev_settings["level"]["moving"]
	Global._settings["level"]["spin"] = prev_settings["level"]["spin"]
	Global._settings["level"]["max_speed"] = prev_settings["level"]["max_speed"]
	update_button_display()
	
func update_button_display():
	$Canvas/Laser.pressed = Global._settings["level"]["laser"]
	$Canvas/Square.pressed = Global._settings["level"]["square"]
	$Canvas/Moving.pressed = Global._settings["level"]["moving"]
	$Canvas/Spin.pressed = Global._settings["level"]["spin"]
	$Canvas/Max.pressed = Global._settings["level"]["max_speed"]


func _on_Room_pressed():
	set_values()
	Global.test_room = true
	Global.testing = true
	get_tree().change_scene("res://src/Level.tscn")


func _on_TouchScreenButton_pressed():
	get_tree().change_scene(Dialogue)



func _on_TouchScreenButton2_pressed():
	if !Global.skip:
		Global.skip = true
		get_tree().change_scene(Tutorial)


func _on_use_pressed():
	if Engine.has_singleton("GodotGooglePlayBilling"):
		payment = Engine.get_singleton("GodotGooglePlayBilling")
	
	var query = payment.queryPurchases("inapp") # Or "subs" for subscriptions
	if query.status == OK:
		for purchase in query.purchases:
			if purchase.purchase_state == 1:
				payment.consumePurchase(purchase.purchase_token)



func _on_bt_pressed():
	Global.data["skins"]["unlocked"].append(7)
#	Global.data["skins"]["selected"] = special_index
#	get_node("../../").skin_index = special_index
#	get_node("../../").set_skin()
	Global.data["multiplier"] = true
	Global.data["no_ads"] = true
	Global.save_data()


func _on_bt2_pressed():
	get_tree().change_scene("res://src/Video.tscn")


func _on_bt4_pressed():
	if reset_count < 2:
		reset_count += 1
		return
	Global.data["no_ads"] = false
	Global.data["admin"] = false
	Global.data["watched"] = null
	Global.data["money"] = 0 
#	get_node("../Money/Money").text = str(Global.data["money"])
	Global.data["abilities"]["unlocked"]  = []
	Global.data["high_score"] = 0.0
	Global.data["items"]["unlocked"]  = []
	Global.data["skins"]["unlocked"]  = [0]
	Global.data["skins"]["selected"]  = 0
	Global.data["abilities"]["selected"]  = null
	Global.data["items"]["selected"]  = null
	Global.data["multiplier"] = false
	Global.item = null
	Global.ability = null
	Global.data["levels"] = {}
#	skin_index = 0
#	set_skin()
#	$popups/items_window.update_buttons()
#	update_buttons()
#	change_button()
#	hide_buttons()
#	place_selected()
#	$popups/items_window.hide_buttons()
#	$popups/items_window.place_selected()
#	for item in $popups/ability_window/prices.get_children():
#		item.queue_free()
##		print(item)
#	for child in $popups/items_window/prices.get_children():
#		child.queue_free()

#	yield(get_tree().create_timer(1), "timeout")


#	place_prices()
#	$popups/items_window.place_prices()

	Global.save_data()


func _on_bt3_pressed():
	Global.data["money"] += 1000
	get_node("../Money/Money").text = str(Global.data["money"])
	Global.save_data()
