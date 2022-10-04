extends Node2D

var skins_path = "res://assets/skins/"
var skin_index
var skin
onready var skins = Global.skins
var prices = {
	"green" : 0,
	"red" : 250,
	"blue" : 250,
	"purple" : 250,
	"orange" : 500,
	"pink" : 250,
#	"light-green" : 450,
	"mint" : 250,
}
var index_to_key = ["green", "red", "blue", "purple", "pink", "mint", "orange"]

var ability
onready var use_button = $popups/ability_window/use
onready var selected = $popups/ability_window/selected
onready var unequip_button = $popups/ability_window/unequip
onready var info_button = $popups/ability_window/info
onready var info = $popups/info_popup
onready var purchase_button = $popups/ability_window/purchase
onready var confirm_popup = $popups/confirm_popup

var bgpos
var pressed = false
onready var info_label = $popups/info_popup/Label
onready var video = $popups/info_popup/video
onready var abil_label = $popups/ability_window/Label
onready var level_board = $popups/ability_window/Level
onready var label_bg = $popups/ability_window/label_bg
var touchable = true

var desc = {
	"float": "Stay in air for [color=#ffef00]( 0.5 / 0.8 / infinite )[/color] seconds.",
	"shrink": "Shrink into [color=#ffef00]( 60% / 50% / 40% )[/color] size.",
	"guard": "Guard an attack.",
	"hook" : "Move towards a wall in mid-air, \n                                        at a [color=#ffef00]( slow / medium / fast )[/color] speed",
	"dodge" : "Turn and dodge! \n(*does not allow you to dash diagonally)",
	"blink" : "Teleport a short distance up to [color=#ffef00]( 1 / 2 / infinite )[/color] times in air",
}

var prices_abil = {
	"float" : 1250,
	"shrink" : 650,
#	"guard" : 700,
	"hook" : 950,
	"dodge" : 75,
	"blink" : 450,
}

var prices_upgrade = {
	"float" : [1500, 2350],
	"shrink" : [950, 1250],
#	"guard" : [500, 700],
	"hook" : [1350, 1950],
	"dodge" : [0, 0],
	"blink" : [750, 900],
	"heal" : [1750, 2500]
}

var popup_temp = null
var price_tag = load("res://src/price_tag.tscn")
var default_order = [
	"float",
	"shrink",
	"guard",
	"hook",
	"dodge",
	"blink",
]
var low_cost_order = [
	"dodge",
	"blink",
	"shrink",
	"hook",
	"float",
	"guard",
]

onready var prices_node = get_node("popups/ability_window/prices")

func _ready():
#	Global.data["skins"]["unlocked"].append(prices.size())
#	Global.data["skins"]["selected"] = prices.size()
	order_abil()
	place_prices()
	
	visible = true
	place_selected()
	hide_popups()
	skin_index = Global.data["skins"]["selected"]
	
	get_node("../Money/Money").text = str(Global.data["money"])
	set_skin()
#	$popups/skins_window.show()
#	$popups/skins_window.visible = true

#q
func order_abil():
#	var saved_pos = Vector2(-697, 104)
	var saved_pos = Vector2(-697, 120)
	var sort_count = 1
	for abil in low_cost_order:
		get_node("popups/ability_window/"+abil).position = saved_pos
		sort_count += 1
		if sort_count == 5:
#			saved_pos += Vector2(-480, 165)
			saved_pos += Vector2(-480, 195)
			sort_count = 1
		else:
			saved_pos += Vector2(160, 0)
			
		
func place_prices():
	
	for item in prices_abil:
		if item in Global.data["abilities"]["unlocked"]:
			continue
#		if item in $prices.get_children():
#			continue
		var price = prices_abil[item]
		var price_tag_instance = price_tag.instance()
		prices_node.add_child(price_tag_instance)
		price_tag_instance.global_position = get_node("popups/ability_window/"+item).global_position + Vector2(5, 115)
		price_tag_instance.get_child(1).text = str(price)
		price_tag_instance.name = item
#		print(price_tag_instance.name)
	
		
func revert_skin_index(index):
	skin_index = index

func revert_skin():
	var skin_index = Global.data["skins"]["selected"]
	var skin = Global.skins[skin_index]
	get_node("../Sprites/Sprite").set_texture(skin)
	$popups/skins_window/price.text = ""
	$popups/skins_window/money.visible = false
	
	revert_skin_index(skin_index)
	change_button()
	

#	print(get_node("popups/items_window/"+Global.ability).position)
	
#func _on_Back_pressed():
#	self.visible = false
#	for popup in $popups.get_children():
#		popup.visible = false


func _on_skins_button_pressed():
	hide_popups()
#	$popups/skins_window.show()
	$popups/skins_window.visible = true
#	$popups/window.visible = true
	
func hide_popups():
#	get_node("prices").visible = false
	for popup in $popups.get_children():
#		popup.hide()
		popup.visible = false

func _on_backgrounds_button_pressed():
	hide_popups()
#	$popups/backgrounds_window.show()
	$popups/backgrounds_window.visible = true
	$popups/window.visible = true
	
#RIGHT
func _on_right_arrow_pressed():
	if skin_index+1 == skins.size()-1:
		if skins.size()-1 in Global.data["skins"]["unlocked"]:
			skin_index = skins.size()-1
		else:
			skin_index = 0
		
	elif skin_index+1 < skins.size():
		skin_index += 1
	
	else:
		skin_index = 0
		
			
	
	set_skin()
	
#LEFT
func _on_left_arrow_pressed():
	if skin_index-1 >= 0:
		skin_index -= 1
	else:
		if skins.size()-1 in Global.data["skins"]["unlocked"]:
			skin_index = skins.size()-1
		else:
			skin_index = skins.size()-2
			
	
	set_skin()
	
func set_skin():
	
	skin = skins[skin_index]

	get_parent().get_node("Sprites/Sprite").set_texture(skin)
	
	if skin_index in Global.data["skins"]["unlocked"]:
		$popups/skins_window/price.text = ""
		$popups/skins_window/money.visible = false
	else:
		#test
		$popups/skins_window/price.text = str(prices[index_to_key[skin_index]])
		$popups/skins_window/money.visible = true
		pass
#W
	change_button()
	
func _on_confirm_pressed():
	Global.data["skins"]["selected"] = skin_index
	change_button()
	Global.save_data()

func _on_purchase_pressed():
	touch_cool()
	if Global.data["money"] >= prices[index_to_key[skin_index]]:
		confirm_popup.visible = true
		get_node("popups/confirm_popup/icon").set_texture(Global.skins[skin_index])
		get_node("popups/confirm_popup/icon").scale = Vector2(0.8, 0.8)
		get_node("popups/confirm_popup/icon").modulate.a = 1.5
		get_node("popups/confirm_popup/price").text = str(prices[index_to_key[skin_index]])
		$popups/skins_window/purchase/purchase.set_block_signals(true)
	
func purchase_skin():
	Global.data["skins"]["unlocked"].append(skin_index)
	Global.data["money"] -= prices[index_to_key[skin_index]]
	get_node("../Money/Money").text = str(Global.data["money"])
	$popups/skins_window/price.text = ""
	$popups/skins_window/money.visible = false
	Global.data["skins"]["selected"] = skin_index
	change_button()
	Global.save_data()
		
func change_button():
	
	if Global.data["skins"]["selected"] == skin_index:
		get_node("popups/skins_window/purchase").visible = false
		get_node("popups/skins_window/confirm").visible = false
		get_node("popups/skins_window/selected").visible = true
	elif skin_index in Global.data["skins"]["unlocked"]:
		get_node("popups/skins_window/purchase").visible = false
		get_node("popups/skins_window/selected").visible = false
		get_node("popups/skins_window/confirm").visible = true 
	else:
		get_node("popups/skins_window/purchase").visible = true
		get_node("popups/skins_window/selected").visible = false
		get_node("popups/skins_window/confirm").visible = false 	

func _on_bg_left_pressed():
	print("yes")
#	get_parent().get_node("Sprites/Lines").modulate = Color(1.2,0,0)
	get_parent().get_node("Sprites/Line").set_texture(load("res://assets/floor line.png"))


func _on_bg_right_pressed():
#	get_parent().get_node("Sprites/Lines").modulate = Color(0,0,1.2)
	get_parent().get_node("Sprites/Line").set_texture(load("res://assets/floor line2.png"))
#	get_parent().get_node("Sprites/Line").modulate = Color(1.5, 1.5, 1.5)


func _on_items_button_pressed():
	hide_popups()
#	$popups/skins_window.show()
	$popups/window.visible = true
	$popups/items_window.visible = true
#	$popups/grid.visible = true
	revert_skin()
	$popups/items_window.hide_buttons()
	$popups/info_popup.visible = false
	$popups/items_window.update_buttons()

func _on_shrink_pressed():
	show_button("shrink")


func touch_cool():
	touchable = false
	yield(get_tree().create_timer(0.1), "timeout")
	touchable = true

func _on_use_pressed():
	touch_cool()
	Global.ability = ability
	Global.save_data()
#	use_button.visible = false
	hide_buttons()
	place_selected()

func _on_float_pressed():
	show_button("float")
	

func show_button(string):
	if !touchable:
		return
	pressed = ability == string
	if !pressed:
		hide_buttons()
		
	ability = string
	
	toggle_label(ability)
	
	if Global.ability == string:
		toggle_vis(unequip_button)
	else:
		if ability in Global.data["abilities"]["unlocked"]:
			toggle_vis(use_button)
		else:
			toggle_vis(purchase_button)
			$popups/ability_window/purchase/price.text = str(prices_abil[ability])
	toggle_info_button()
	
func toggle_vis(button):
	if button.visible and pressed:
		button.visible = false

	else:
		button.visible = true
#		button.position = get_node("popups/ability_window/"+ability).position + Vector2(-15,100)
		if ability != "dodge" and ability in Global.data["levels"]:
			button.position = get_node("popups/ability_window/"+ability).position + Vector2(-15,160)
		else:
			button.position = get_node("popups/ability_window/"+ability).position + Vector2(-15,130)
		
func toggle_info_button():

	if info_button.visible and pressed:
		info_button.visible = false
		ability = null
		
	else:
		info_button.visible = true
#		info_button.position = get_node("popups/ability_window/"+ability).position + Vector2(-15,160)
		if ability != "dodge" and ability in Global.data["levels"]:									#211.5
			info_button.position = get_node("popups/ability_window/"+ability).position + Vector2(-15,211) #220
		else:																						#181.5
			info_button.position = get_node("popups/ability_window/"+ability).position + Vector2(-15,181) #190
			
func toggle_label(string):
	string = string[0].to_upper() + string.substr(1, -1)
	if abil_label.visible and pressed:
		abil_label.visible = false
		label_bg.visible = false
		level_board.visible = false
		
	else:
		abil_label.text = string
		abil_label.visible = true
		label_bg.visible = true
		label_bg.position = get_node("popups/ability_window/"+ability).position + Vector2(-8,95)
		abil_label.rect_position = get_node("popups/ability_window/"+ability).position + Vector2(-2,95)
#		abil_label.rect_position = Vector2(150, 150)
		if ability != "dodge" and ability in Global.data["levels"]:
			level_board.visible = true
			level_board.position = get_node("popups/ability_window/"+ability).position + Vector2(-8,125)
			
			var level = Global.data["levels"][ability]
			level_board.get_child(1).visible = true
			level_board.get_child(1).texture = load("res://assets/shop_buttons/level"+str(level)+".png")
		
		else:
			
			level_board.get_child(1).visible = false

func _on_guard_pressed():
	show_button("guard")
	

func place_selected():
	if Global.ability:
		selected.position = get_node("popups/ability_window/"+Global.ability).position
	else:
		selected.position = Vector2(-1200,-300)
	
func _on_ability_button_pressed():
	hide_popups()
	prices_node.visible = true
#	$popups/skins_window.show()
	$popups/ability_window.visible = true
	revert_skin()
	$popups/window.visible = true
	hide_buttons()
	update_buttons()

func hide_buttons():
	use_button.visible = false
	unequip_button.visible = false
	info_button.visible = false
	purchase_button.visible = false
	abil_label.visible = false
	level_board.visible = false
	label_bg.visible = false


func _on_blank_pressed():
	hide_buttons()
	$popups/items_window.hide_buttons()


func _on_unequip_pressed():
	touch_cool()
	Global.ability = null
	ability = null
	Global.save_data()
#	unequip_button.visible = false
	hide_buttons()
	place_selected()


func _on_info_pressed():
	$buttons/skins_button.set_block_signals(true)
	$buttons/ability_button.set_block_signals(true)
	$buttons/items_button.set_block_signals(true)
	get_node("../Money/charge").set_block_signals(true)
	touchable = false
	info.get_node("upgrade").normal = load("res://assets/shop_buttons/buy.png")

#	touch_cool()
	hide_buttons()
	info.type = "abilities"
	info.id = ability
	info_label.bbcode_text = desc[ability]
	info.visible = true
	var level
	if ability in Global.data["levels"]:
		info.get_node("Level").visible = true
		if Global.data["levels"][ability] == 3:
			info.get_node("max").visible = true
			info.get_node("upgrade").normal = load("res://assets/shop_buttons/max.png")
			info.get_node("action").text = ""
			info.get_node("money").visible = false
			info.get_node("price").text = ""
		else:
			info.get_node("max").visible = false
			info.get_node("money").visible = true
			info.get_node("price").text = str(prices_upgrade[ability][Global.data["levels"][ability]-1])
			info.get_node("action").text = "Upgrade:"
			info.get_node("upgrade").normal = load("res://assets/shop_buttons/upgrade.png")
#		level = str(min(Global.data["levels"][ability] + 1, 3))
		level = str(Global.data["levels"][ability])
	else:
		info.get_node("max").visible = false
		info.get_node("Level").visible = false
		level = str(1)
		info.get_node("money").visible = true
		info.get_node("price").text = str(prices_abil[ability])
#		info.get_node("upgrade").normal = load("res://assets/button_bg.png")
		info.get_node("action").text = "Purchase:"
		info.get_node("upgrade").normal = load("res://assets/shop_buttons/buy2.png")
#	print(level)
	info.reset_buttons()
	info.get_node("Level/num").texture = load("res://assets/shop_buttons/level"+level+".png")
#	info.get_node("level"+level).normal = load("res://assets/button_bg.png")
#	video.stream = load("res://assets/videos/"+ability+"_"+level+".webm")
	info.get_node("demo").normal = load("res://assets/button_bg.png")
	info.get_node("video").stream = load("res://assets/videos/"+ability+"_demo.webm")
	
	video.play()
	
	if ability == "dodge":
		if ability in Global.data["abilities"]["unlocked"]:
			info.get_node("max").visible = true
			info.get_node("upgrade").normal = load("res://assets/shop_buttons/max.png")
			info.get_node("action").text = ""
			info.get_node("money").visible = false
			info.get_node("price").text = ""
		info.get_node("Level").visible = false
		info.get_node("level2").visible = false
		info.get_node("level3").visible = false
		info.get_node("Label6").visible = false
		info.get_node("Label3").visible = false
		info.get_node("Label4").visible = false
	else:
		info.get_node("level2").visible = true
		info.get_node("level3").visible = true
		info.get_node("Label6").visible = true
		info.get_node("Label3").visible = true
		info.get_node("Label4").visible = true
		#test
func _on_hack_pressed():
	Global.data["money"] += 1000
	get_node("../Money/Money").text = str(Global.data["money"])
	Global.save_data()

func _on_purchase_abil_pressed():
	
	attempt_abil_purchase()
#		purchase()

func attempt_abil_purchase():
	if Global.data["money"] >= prices_abil[ability]:
		info.toggle_buttons(true)
		touchable = false
		confirm_popup.visible = true
		get_node("popups/confirm_popup/icon").set_texture(load("res://assets/abilities/"+ability+".png"))
		get_node("popups/confirm_popup/price").text = str(prices_abil[ability])
		get_node("popups/confirm_popup/icon").scale = Vector2(0.15, 0.15)
		
		get_node("popups/confirm_popup/icon").modulate.a = 1
		hide_buttons()

func purchase():
	hide_buttons()
	Global.data["abilities"]["selected"] = ability
	Global.ability = ability
#	print("to delete"+ability)
	get_node("popups/ability_window/prices/"+ability).queue_free()
	place_selected()
	Global.data["abilities"]["unlocked"].append(ability)
	Global.data["levels"][ability] = 1
	Global.data["money"] -= prices_abil[ability]
	get_node("../Money/Money").text = str(Global.data["money"])
	Global.save_data()
	update_buttons()
	if info.visible:
		info.touch_cool()
		info.reset_buttons()
		info.get_node("level1").normal = load("res://assets/button_bg.png")
		info.get_node("video").stream = load(ability+"_1.webm")
		info.get_node("video").play()
		info.get_node("Level/num").texture = load("res://assets/shop_buttons/level1.png")
		
		info.get_node("price").text = str(prices_upgrade[ability][Global.data["levels"][ability]-1])
		info.get_node("action").text = "Upgrade:"
		info.get_node("upgrade").normal = load("res://assets/shop_buttons/upgrade.png")
		info.get_node("Level").visible = true
		
		if ability == "dodge":
			info.get_node("max").visible = true
			info.get_node("upgrade").normal = load("res://assets/shop_buttons/max.png")
			info.get_node("action").text = ""
			info.get_node("money").visible = false
			info.get_node("price").text = ""
			info.get_node("Level").visible = false
		#test
func _on_hack2_pressed():
	Global.data["watched"] = null
	Global.data["money"] = 0 
	get_node("../Money/Money").text = str(Global.data["money"])
	Global.data["abilities"]["unlocked"]  = []
	Global.data["highscore"] = null
	Global.data["items"]["unlocked"]  = []
	Global.data["skins"]["unlocked"]  = [0]
	Global.data["skins"]["selected"]  = 0
	Global.data["abilities"]["selected"]  = null
	Global.data["items"]["selected"]  = null
	Global.data["multiplier"] = false
	Global.item = null
	Global.ability = null
	Global.data["levels"] = {}
	skin_index = 0
	set_skin()
	$popups/items_window.update_buttons()
	update_buttons()
	change_button()
	hide_buttons()
	place_selected()
	$popups/items_window.hide_buttons()
	$popups/items_window.place_selected()
	for item in $popups/ability_window/prices.get_children():
		item.queue_free()
#		print(item)
	for child in $popups/items_window/prices.get_children():
		child.queue_free()

	yield(get_tree().create_timer(1), "timeout")


	place_prices()
	$popups/items_window.place_prices()

	Global.save_data()

func update_buttons():
	for item in prices_abil:
		if item in Global.data["abilities"]["unlocked"]:
			var item_button = get_node("popups/ability_window/"+item)
			item_button.normal = (load("res://assets/abilities/"+item+".png"))
		else:
			var item_button = get_node("popups/ability_window/"+item)
			item_button.normal = (load("res://assets/abilities/"+item+"_locked.png"))
			


func _on_no_pressed():
	if !info.visible:
		touchable = true
		$popups/items_window.touchable = true
	info.toggle_buttons(false)
	
	confirm_popup.visible = false
	yield(get_tree().create_timer(0.1), "timeout")
	$popups/skins_window/purchase/purchase.set_block_signals(false)

func _on_yes_pressed():
#	touch_cool()
	if !info.visible:
		touchable = true
		$popups/items_window.touchable = true
	info.toggle_buttons(false)
	
	if $popups/ability_window.visible:
		purchase()
	elif $popups/items_window.visible:
		$popups/items_window.purchase()
	else:
		purchase_skin()
	confirm_popup.visible = false
	yield(get_tree().create_timer(0.1), "timeout")
	$popups/skins_window/purchase/purchase.set_block_signals(false)


func _on_charge_pressed():
	self.visible = true
	if $popups/ability_window.visible:
		popup_temp = $popups/ability_window
	elif $popups/items_window.visible:
		popup_temp = $popups/items_window
	elif $popups/skins_window.visible:
		popup_temp = $popups/skins_window
	elif get_node("../Settings").visible:
		get_node("../Settings").visible = false
		popup_temp = get_node("../Settings")
	else:
		get_node("../Popup").visible = false
		get_node("../Play").visible = false
		get_node("../Reward").visible = false
	get_node("buttons").visible = false
	hide_popups()
	$popups/charge_window/coins_window.visible = true
	$popups/charge_window/others_window.visible = false
	$popups/charge_window.visible = true
	get_node("../Back").visible = true
	


func _on_hook_pressed():
	show_button("hook")


func _on_test_pressed():
	show_button("dodge")



func _on_flash_pressed():
	show_button("blink")


func _on_dodge_pressed():
	show_button("dodge")


func _on_blink_pressed():
	show_button("blink")
