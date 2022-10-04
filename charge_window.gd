extends Node2D

var payment
var itemToken
onready var Money = get_node("../../../Money/Money")
var list_of_consumable_products = ["500_coins", "1500_coins", "3750_coins", "7500_coins", "21500_coins", "50000_coins2"]
var temp_purchase
var special_index
#var special_index=  8

func _ready():
	special_index = get_node("../../").prices.size()
	hide_info_icons()
	$others_window/info.visible = false
	if Global.data["no_ads"]:
		$others_window/no_ads.normal = load("res://assets/button_bg.png")	
	if Global.data["multiplier"]:
		$others_window/multiplier.normal = load("res://assets/button_bg.png")
	if Global.data["skins"]["unlocked"].has(special_index):
		$others_window/skin.normal = load("res://assets/button_bg.png")
	
	if Engine.has_singleton("GodotGooglePlayBilling"):
		payment = Engine.get_singleton("GodotGooglePlayBilling")

		# These are all signals supported by the API
		# You can drop some of these based on your needs
		payment.connect("connected", self, "connected") # No params
		payment.connect("disconnected", self, "disconnected") # No params
		payment.connect("connect_error", self, "connect_error") # Response ID (int), Debug message (string)
		payment.connect("purchases_updated", self, "purchases_updated") # Purchases (Dictionary[])
		payment.connect("purchase_error", self, "purchase_error") # Response ID (int), Debug message (string)
		payment.connect("sku_details_query_completed", self, "sku_details_query_completed") # SKUs (Dictionary[])
		payment.connect("sku_details_query_error", self, "sku_details_query_error") # Response ID (int), Debug message (string), Queried SKUs (string[])
		payment.connect("purchase_acknowledged", self, "purchase_acknowledged") # Purchase token (string)
		payment.connect("purchase_acknowledgement_error", self, "purchase_acknowledgement_error") # Response ID (int), Debug message (string), Purchase token (string)
		payment.connect("purchase_consumed", self, "purchase_consumed") # Purchase token (string)
		payment.connect("purchase_consumption_error", self, "purchase_consumption_error") # Response ID (int), Debug message (string), Purchase token (string)

		payment.startConnection()

func connected():
#	$Connected.visible = true
	payment.querySkuDetails(["500_coins", "1500_coins", "3750_coins", "7500_coins", "21500_coins", "50000_coins2", "no_ads2", "multiplier", "skin"], "inapp")
	
#func purchases_updated(items):
#	$PurchaseUpdated.visible = true
#	for item in items:
#		if !item.is_acknowledged:
#			payment.acknowledgePurchase(item.purchase_token)
#	if items.size() > 0:
#		$ItemAck.visible = true
#		itemToken = items[items.size()-1].purchase_token
#		use_token()
func purchases_updated(purchases):
#	$PurchaseUpdated.visible = true
	for purchase in purchases:
		if purchase.purchase_state == 1:
			useItem(purchase)
			if not purchase.is_acknowledged:
				temp_purchase = purchase
				payment.acknowledgePurchase(purchase.purchase_token)
				
func use_token():
	if itemToken == null:
#		$ItemNull.visible = true
		pass
	else:
		payment.consumePurchase(itemToken)
#		$ItemNotNull.visible = true

func useItem(purchase):
	if purchase.sku == "500_coins":
		increase_money(500)
	elif purchase.sku == "1500_coins":
		increase_money(1500)
	elif purchase.sku == "3750_coins":	
		increase_money(3750)
	elif purchase.sku == "7500_coins":
		increase_money(7500)
	elif purchase.sku == "21500_coins":
		increase_money(21500)
	elif purchase.sku == "50000_coins2":
		increase_money(50000)
		
	elif purchase.sku == "no_ads2":
		Global.data["no_ads"] = true
		Global.save_data()
		$others_window/no_ads.normal = load("res://assets/button_bg.png")
	
	elif purchase.sku == "multiplier":
		Global.data["multiplier"] = true
		Global.save_data()
		$others_window/multiplier.normal = load("res://assets/button_bg.png")
	elif purchase.sku == "skin":
		Global.data["skins"]["unlocked"].append(special_index)
		Global.data["skins"]["selected"] = special_index
		get_node("../../").skin_index = special_index
		get_node("../../").set_skin()
		Global.save_data()
		$others_window/skin.normal = load("res://assets/button_bg.png")
		
func increase_money(num):
	Global.data["money"] += num
	Money.text = str(Global.data["money"])
	Global.save_data()

func purchase_consumed(_token):
#	itemToken = null
#	Global.data["money"] += 1000
#	Money.text = str(Global.data["money"])
#	Global.save_data()
	$ItemNotNull.visible = false
	$PurchaseAck.visible = false
	$ItemAck.visible = false
	$PurchaseUpdated.visible = false
	$BuyFail.visible = false
	$Connected.visible = false

#func _on_use_pressed():
#	use_token()

func purchase_acknowledged(_token):
#	$PurchaseAck.visible = true
	var purchase = temp_purchase
	if list_of_consumable_products.has(purchase.sku):
		payment.consumePurchase(purchase.purchase_token)

func _on_buy1_pressed():
	var response = payment.purchase("500_coins")

	if response.status != OK:
#		pass
		$BuyFail.visible = true

#func _on_charge_pressed():
#	get_node("../../buttons").visible = false
#	get_parent().get_parent().hide_popups()
#	$others_window.visible = false
#	visible = true
#	get_node("../../../Back").visible = true



func _on_coins_pressed():
	$coins_window.visible = true
	$others_window.visible = false


func _on_other_pressed():
	$coins_window.visible = false
	$others_window.visible = true



#func _on_button_pressed():
#	if Engine.has_singleton("GodotGooglePlayBilling"):
#		$Other.visible = false
#	else:
#		$Coins.visible = false


func _on_buy2_pressed():
	var response = payment.purchase("1500_coins")

	if response.status != OK:
		$BuyFail.visible = true


func _on_buy3_pressed():
	var response = payment.purchase("3750_coins")

	if response.status != OK:
		$BuyFail.visible = true


func _on_buy4_pressed():
	var response = payment.purchase("7500_coins")

	if response.status != OK:
		$BuyFail.visible = true


func _on_buy5_pressed():
	var response = payment.purchase("21500_coins")

	if response.status != OK:
		$BuyFail.visible = true


func _on_buy6_pressed():
	var response = payment.purchase("50000_coins2")

	if response.status != OK:
		$BuyFail.visible = true


func _on_noAds_pressed():
	var response = payment.purchase("no_ads2")

	if response.status != OK:
		$BuyFail.visible = true


func _on_multiplier_pressed():
	var response = payment.purchase("multiplier")

	if response.status != OK:
		$BuyFail.visible = true


func _on_skin_pressed():
	var response = payment.purchase("skin")

	if response.status != OK:
		$BuyFail.visible = true


func _on_use_pressed(): 
	
	var query = payment.queryPurchases("inapp") # Or "subs" for subscriptions
	if query.status == OK:
		for purchase in query.purchases:
			if purchase.purchase_state == 1:
				payment.consumePurchase(purchase.purchase_token)


func _on_bt_pressed():
	Global.data["skins"]["unlocked"].append(special_index)
	Global.data["skins"]["selected"] = special_index
	get_node("../../").skin_index = special_index
	get_node("../../").set_skin()
	Global.data["multiplier"] = true
	Global.save_data()


func _on_multiplier_info_pressed():
	$others_window/info.visible = true
	hide_info_icons()
	$others_window/info/multiplier_icon.visible = true
	$others_window/info/multiplier_label.visible = true

func _on_close_pressed():
	$others_window/info.visible = false


func _on_ad_info_pressed():
	$others_window/info.visible = true
	hide_info_icons()
	$others_window/info/ad_icon.visible = true
	$others_window/info/ad_label.visible = true

func _on_skin_info_pressed():
	$others_window/info.visible = true
	hide_info_icons()
	$others_window/info/skin_icon.visible = true
	$others_window/info/skin_label.visible = true

func hide_info_icons():
	$others_window/info/ad_icon.visible = false
	$others_window/info/multiplier_icon.visible = false
	$others_window/info/skin_icon.visible = false
	$others_window/info/ad_label.visible = false
	$others_window/info/multiplier_label.visible = false
	$others_window/info/skin_label.visible = false


func _on_no_ads_pressed():
	var response = payment.purchase("no_ads2")

	if response.status != OK:
		$BuyFail.visible = true
