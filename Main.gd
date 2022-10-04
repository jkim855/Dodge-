extends Node2D

const save_path = "user://savedata.save"
onready var money_label = $CanvasLayer/Money

func _ready():
	money_label.text = str(Global.data["money"])
#	pass

#func _on_Play_pressed():
#	Global.test = false
#	Global.testing = false
#	if get_tree().change_scene("res://src/Level.tscn") != OK:
#		print("Error during [Change Scene]")

func _process(_delta):
	if Input.is_action_just_pressed("Enter"):
		if get_tree().change_scene("res://src/Level.tscn") != OK:
			print("Error during [Change Scene]")


func _on_Settings_pressed():
	if get_tree().change_scene("res://src/Settings.tscn") != OK:
		print("Error during [Change Scene]")


func _on_Store_pressed():
	if get_tree().change_scene("res://src/Shop.tscn") != OK:
		print("Error during [Change Scene]")


func _on_Test_pressed():
	if get_tree().change_scene("res://src/Test.tscn") != OK:
		print("Error during [Change Scene]")


func _on_Play_released():
	Global.test = false
	Global.testing = false
	if get_tree().change_scene("res://src/Level.tscn") != OK:
		print("Error during [Change Scene]")


func _on_Intro_pressed():
	if get_tree().change_scene("res://src/Intro.tscn") != OK:
		print("Error during [Change Scene]")
