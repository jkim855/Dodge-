extends Node2D

var skins_path = "res://assets/skins/"
var skin_index
var skin
onready var skins = Global.skins
var prices = {
	"green" : 0,
	"red" : 10,
	"blue" : 10,
	"purple" : 20,
	"cyan" : 30,
	"yellow" : 30,
}
var index_to_key = ["green", "red", "blue", "purple", "cyan", "yellow"]

func _ready():
	print(Global.skins)
	skin_index = Global.data["skins"]["selected"]
	$Sprite/Money.text = str(Global.data["money"])
	set_skin()
#	$popups/skins_window.show()
#	$popups/skins_window.visible = true

func _on_Back_pressed():
	get_tree().change_scene("res://src/Main.tscn")


func _on_skins_button_pressed():
	hide_popups()
#	$popups/skins_window.show()
	$popups/skins_window.visible = true
	
func hide_popups():
	for popup in $popups.get_children():
#		popup.hide()
		popup.visible = false

func _on_backgrounds_button_pressed():
	hide_popups()
#	$popups/backgrounds_window.show()
	$popups/backgrounds_window.visible = true

#RIGHT
func _on_right_arrow_pressed():
	if skin_index+1 < skins.size():
		skin_index += 1
	else:
		skin_index = 0
	set_skin()
	
#LEFT
func _on_left_arrow_pressed():
	if skin_index-1 >= 0:
		skin_index -= 1
	else:
		skin_index = skins.size()-1
	set_skin()
	
func set_skin():
	print(Global.skins)
	skin = skins[skin_index]

	$popups/skins_window/Sprite.set_texture(skin)
	
	if skin_index in Global.data["skins"]["unlocked"]:
		$popups/skins_window/price.text = ""
	else:
		#test
#		$popups/skins_window/price.text = str(prices[index_to_key[skin_index]])
		pass
#W
	change_button()
	
func _on_confirm_pressed():
	Global.data["skins"]["selected"] = skin_index
	Global.save_data()

func _on_purchase_pressed():
	if Global.data["money"] >= prices[index_to_key[skin_index]]:
		Global.data["skins"]["unlocked"].append(skin_index)
		Global.data["money"] -= prices[index_to_key[skin_index]]
		$Sprite/Money.text = str(Global.data["money"])
		$popups/skins_window/price.text = ""
		Global.save_data()
		change_button()
		
func change_button():
	
	if skin_index in Global.data["skins"]["unlocked"]:
		get_node("popups/skins_window/purchase").visible = false
		get_node("popups/skins_window/confirm").visible = true 
	else:
		get_node("popups/skins_window/purchase").visible = true
		get_node("popups/skins_window/confirm").visible = false 	
