extends Node2D

onready var upgrade_window = get_node("../confirm_upgrade")
var type
var id
var price

func _ready():
	pass


func _on_video_finished():
	$video.play()


func _on_upgrade_pressed():
	if id in Global.data["levels"] and Global.data["levels"][id] != 3:
		price = get_node("../../").prices_upgrade[id][Global.data["levels"][id]-1]
		if Global.data["money"] >= price: 
			upgrade_window.visible = true
			
			upgrade_window.get_child(4).text = str(price)
			upgrade_window.get_child(1).texture = load("res://assets/"+type+"/"+id+".png")
		
			toggle_buttons(true)
	else:
#		print(type)
		if type == "abilities":
			get_node("../../").attempt_abil_purchase()
		elif type == "items":
			get_node("../items_window").attempt_item_purchase()	
		
func toggle_buttons(block):
	$level1.set_block_signals(block)
	$level2.set_block_signals(block)
	$level3.set_block_signals(block)
	$upgrade.set_block_signals(block)
	get_node("../../../Back").set_block_signals(block)

func _on_no_pressed():
	upgrade_window.visible = false
	toggle_buttons(false)
	
func touch_cool():
	toggle_buttons(true)
	yield(get_tree().create_timer(0.1), "timeout")
	toggle_buttons(false)

func _on_yes_pressed():
	touch_cool()
	if Global.data["money"] >= price:
		
		Global.data["levels"][id] += 1
		Global.data["money"] -= price
		get_node("../../../Money/Money").text = str(Global.data["money"])
		Global.save_data()
		upgrade_window.visible = false
	
		Global.save_data()
		
#		toggle_buttons(false)
		$video.stream = load("res://assets/videos/"+id+"_"+str(Global.data["levels"][id])+".webm")
		$video.play()
		reset_buttons()
		
		get_node("level"+str(Global.data["levels"][id])).normal = load("res://assets/button_bg.png")
		if Global.data["levels"][id] == 3:
				get_node("upgrade").normal = load("res://assets/shop_buttons/max.png")
				get_node("max").visible = true
				get_node("action").text = ""
				get_node("money").visible = false
				get_node("price").text = ""
		else:
			get_node("money").visible = true
			get_node("price").text = str(get_node("../../").prices_upgrade[id][Global.data["levels"][id]-1])
			get_node("action").text = "Upgrade:"
		
		
		get_node("Level/num").texture = load("res://assets/shop_buttons/level"+str(Global.data["levels"][id])+".png")
func _on_level1_pressed():
	
	$video.stream = load("res://assets/videos/"+id+"_1.webm")
	$video.play()
	reset_buttons()
	$level1.normal = load("res://assets/button_bg.png")

func _on_level2_pressed():
	
	$video.stream = load("res://assets/videos/"+id+"_2.webm")
	$video.play()
	reset_buttons()
	$level2.normal = load("res://assets/button_bg.png")

func _on_level3_pressed():
	
	$video.stream = load("res://assets/videos/"+id+"_3.webm")
	$video.play()
	reset_buttons()
	$level3.normal = load("res://assets/button_bg.png")

func reset_buttons():
	$level1.normal = load("res://assets/shop_buttons/iap.png")
	$level2.normal = load("res://assets/shop_buttons/iap.png")
	$level3.normal = load("res://assets/shop_buttons/iap.png")
	$demo.normal = load("res://assets/shop_buttons/iap.png")

func _on_demo_pressed():
	$video.stream = load("res://assets/videos/"+id+"_demo.webm")
	$video.play()
	reset_buttons()
	$demo.normal = load("res://assets/button_bg.png")

