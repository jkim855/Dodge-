extends Node2D

onready var use_button = $use
onready var unequip_button = $unequip
onready var selected = $selected
onready var info_button = $info
onready var purchase_button = $purchase
onready var info = get_node("../info_popup")
onready var info_label = get_node("../info_popup/Label")
onready var money = get_node("../../../Money/Money")
var pressed = false
onready var confirm_popup = get_node("../confirm_popup")
onready var price_tag = load("res://src/price_tag.tscn")

var bgpos
var item

var desc = {
	"jump+1": "Jump one more time in air",
	"dash+1": "Dash one more time in air",
	"heal" : "Health packs appear [color=#ffef00]( 10 / 20 / 30 )[/color] seconds faster"
}

var prices = {
	"jump+1" : 1200,
	"dash+1" : 850,
	"heal" : 1500
}
var low_cost_order = [
	"dash+1",
	"jump+1",
	"heal",
]
var default_order = [
	"jump+1",
	"dash+1",
	"heal",
]
onready var item_label = $Label
onready var level_board = $Level
onready var label_bg = $label_bg
var touchable = true

func _ready():
	order_items()
	place_prices()
	place_selected()


func update_buttons():
	for item in prices:
		if item in Global.data["items"]["unlocked"]:
			var item_button = get_node(item)
			item_button.normal = (load("res://assets/items/"+item+".png"))
		else:
			var item_button = get_node(item)
			item_button.normal = (load("res://assets/items/"+item+"_locked.png"))
			
func _on_jump_pressed():
	show_button("jump+1")

func touch_cool():
	touchable = false
	yield(get_tree().create_timer(0.1), "timeout")
	touchable = true

func show_button(string):
	if !touchable:
		return
	pressed = item == string
	if !pressed:
		hide_buttons()
	item = string
	toggle_label(item)

	if Global.item == string:
		toggle_vis(unequip_button)
	else:
		if item in Global.data["items"]["unlocked"]:
			toggle_vis(use_button)
		else:
			toggle_vis(purchase_button)
			$purchase/price.text = str(prices[item])
	toggle_info_button()

func toggle_vis(button):

	if button.visible and pressed:
		button.visible = false

	else:
		button.visible = true
#		button.position = get_node(item).position + Vector2(-15,100)
		if !(item == "jump+1" or item == "dash+1") and item in Global.data["levels"]:
			button.position = get_node(item).position + Vector2(-15,160)
		else:
			button.position = get_node(item).position + Vector2(-15,128)
		
func toggle_info_button():

	if info_button.visible and pressed:
		info_button.visible = false
		item = null
		
	else:
		info_button.visible = true
#		info_button.position = get_node(item).position + Vector2(-15,160)
		if !(item == "jump+1" or item == "dash+1") and item in Global.data["levels"]:
			info_button.position = get_node(item).position + Vector2(-15,211)
		else:
			info_button.position = get_node(item).position + Vector2(-15,181)

func toggle_label(string):
	string = string[0].to_upper() + string.substr(1, -1)
	if item_label.visible and pressed:
		item_label.visible = false
		label_bg.visible = false
		level_board.visible = false
		
	else:
		item_label.text = string
		if string == "Jump+1" or string == "Dash+1":
			item_label.text = string.substr(0,5)	
		item_label.visible = true
		label_bg.visible = true
		label_bg.position = get_node(item).position + Vector2(-8,95)
		item_label.rect_position = get_node(item).position + Vector2(-2,95)
#		item_label.rect_position = Vector2(150, 150)
		if item != "test" and item in Global.data["levels"]:
			level_board.visible = true
			level_board.position = get_node(item).position + Vector2(-8,125)
			
			var level = Global.data["levels"][item]
			level_board.get_child(1).visible = true
			level_board.get_child(1).texture = load("res://assets/shop_buttons/level"+str(level)+".png")
		
		else:
			
			level_board.get_child(1).visible = false


func hide_buttons():
	use_button.visible = false
	unequip_button.visible = false
	info_button.visible = false
	purchase_button.visible = false
	item_label.visible = false
	level_board.visible = false
	label_bg.visible = false
#	item = null

func _on_stick_pressed():
	show_button("stick")

func _on_use_pressed():
	touch_cool()
	Global.item = item
	Global.save_data()
#	use_button.visible = false
	hide_buttons()
	place_selected()
	
func place_selected():
	if Global.item:
		selected.position = get_node(Global.item).position 
	else:
		selected.position = Vector2(-1200,-300)

func _on_dash_pressed():
	show_button("dash+1")

func _on_unequip_pressed():
	touch_cool()
	Global.item = null
	item = null
	Global.save_data()
#	unequip_button.visible = false
	hide_buttons()
	place_selected()


func _on_info_pressed():
	get_node("../../buttons/skins_button").set_block_signals(true)
	get_node("../../buttons/ability_button").set_block_signals(true)
	get_node("../../buttons/items_button").set_block_signals(true)
	get_node("../../../Money/charge").set_block_signals(true)
	touchable = false
	info.get_node("upgrade").normal = load("res://assets/shop_buttons/buy.png")
	
	
	hide_buttons()
	info.type = "items"
	info.id = item
	info_label.bbcode_text = desc[item]
	info.visible = true
	var level
	if item in Global.data["levels"]:
		info.get_node("Level").visible = true
		if Global.data["levels"][item] == 3:
			info.get_node("max").visible = true
			info.get_node("upgrade").normal = load("res://assets/shop_buttons/max.png")
			info.get_node("action").text = ""
			info.get_node("money").visible = false
			info.get_node("price").text = ""
		else:
			if item == "jump+1" or item == "dash+1":
				info.get_node("max").visible = true
				info.get_node("upgrade").normal = load("res://assets/shop_buttons/max.png")
				info.get_node("action").text = ""
				info.get_node("money").visible = false
				info.get_node("price").text = ""
				info.get_node("Level").visible = false
			else:
				info.get_node("max").visible = false
				info.get_node("money").visible = true
				info.get_node("price").text = str(get_node("../../").prices_upgrade[item][Global.data["levels"][item]-1])
				info.get_node("action").text = "Upgrade:"
				info.get_node("upgrade").normal = load("res://assets/shop_buttons/upgrade.png")
#		level = str(min(Global.data["levels"][item] + 1, 3))
		level = str(Global.data["levels"][item])
	else:
		info.get_node("max").visible = false
		info.get_node("Level").visible = false
		level = str(1)
		info.get_node("money").visible = true
		info.get_node("price").text = str(prices[item])
#		info.get_node("upgrade").normal = load("res://assets/button_bg.png")
		info.get_node("action").text = "Purchase:"
		info.get_node("upgrade").normal = load("res://assets/shop_buttons/buy2.png")
#	print(level)
	info.reset_buttons()
	info.get_node("Level/num").texture = load("res://assets/shop_buttons/level"+level+".png")
#	info.get_node("level"+level).normal = load("res://assets/button_bg.png")
#	info.get_node("video").stream = load("res://assets/videos/"+item+"_"+level+".webm")
	info.get_node("demo").normal = load("res://assets/button_bg.png")
	info.get_node("video").stream = load("res://assets/videos/"+item+"_demo.webm")
	info.get_node("video").play()
	
	if item == "jump+1" or item == "dash+1":
		if item in Global.data["items"]["unlocked"]:
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

func _on_close_pressed():
	info.visible = false


func _on_purchase_pressed():
	
	attempt_item_purchase()

func attempt_item_purchase():
	if Global.data["money"] >= prices[item]:
		touchable = false
		info.toggle_buttons(true)
		confirm_popup.visible = true
		get_node("../confirm_popup/icon").set_texture(load("res://assets/items/"+item+".png"))
		get_node("../confirm_popup/price").text = str(prices[item])
		get_node("../confirm_popup/icon").scale = Vector2(0.15, 0.15)
		get_node("../confirm_popup/icon").modulate.a = 1
		hide_buttons()
		

func purchase():
	hide_buttons()
	Global.data["items"]["selected"] = item
	Global.item = item
	place_selected()
	get_node("prices/"+item).queue_free()
	print(get_node("prices").get_children())
	Global.data["items"]["unlocked"].append(item)
	Global.data["levels"][item] = 1
	Global.data["money"] -= prices[item]
	money.text = str(Global.data["money"])
	Global.save_data()
	update_buttons()
	if info.visible:
		info.touch_cool()
		info.reset_buttons()

		info.get_node("level1").normal = load("res://assets/button_bg.png")
		info.get_node("video").stream = load("res://assets/videos/"+item+"_1.webm")
		info.get_node("video").play()
		info.get_node("Level/num").texture = load("res://assets/shop_buttons/level1.png")
		
		
		
		if item == "jump+1" or item == "dash+1":
			info.get_node("max").visible = true
			info.get_node("upgrade").normal = load("res://assets/shop_buttons/max.png")
			info.get_node("action").text = ""
			info.get_node("money").visible = false
			info.get_node("price").text = ""
			info.get_node("Level").visible = false
		
		else:
			info.get_node("price").text = str(get_node("../../").prices_upgrade[item][Global.data["levels"][item]-1])
			info.get_node("action").text = "Upgrade:"
			info.get_node("upgrade").normal = load("res://assets/shop_buttons/upgrade.png")
			info.get_node("Level").visible = true
			
func _on_heal_pressed():
	show_button("heal")

func place_prices():
	
	for id in prices:
		if id in Global.data["items"]["unlocked"]:
			continue
#		if item in $prices.get_children():
#			continue
		var price = prices[id]
		var price_tag_instance = price_tag.instance()
		get_node("prices").add_child(price_tag_instance)
		price_tag_instance.global_position = get_node(id).global_position + Vector2(5, 115)
		price_tag_instance.get_child(1).text = str(price)
		price_tag_instance.name = id
#		print(price_tag_instance.name)
	
func order_items():
#	var saved_pos = Vector2(-697, 104)
	var saved_pos = Vector2(-697, 120)
	var sort_count = 1
	for id in low_cost_order:
		get_node(id).position = saved_pos
		sort_count += 1
		if sort_count == 5:
#			saved_pos += Vector2(-480, 165)
			saved_pos += Vector2(-480, 195)
			sort_count = 1
		else:
			saved_pos += Vector2(160, 0)
