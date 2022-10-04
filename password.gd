extends Control

var pressed = 0

func _ready():
#	Global.data["admin"] = false
#	Global.save_data()
#	$TextEdit.grab_focus()
	pass

func _on_Back_pressed():
	get_tree().change_scene("res://src/Intro.tscn")


#func _on_ok_pressed():
#	if $LineEdit.text == "dodge0420failed":
#		Global.data["admin"] = true
#		Global.save_data()
#		get_tree().change_scene("res://src/Test.tscn")



func _on_1_pressed():
	$text.text += "1"


func _on_c_pressed():
	$text.text = ""
	pressed = 0


func _on_2_pressed():
	$text.text += "2"


func _on_3_pressed():
	$text.text += "3"


func _on_ok_pressed():
	if pressed >= 3 and $text.text == "0420":
		Global.data["admin"] = true
		Global.save_data()
		get_tree().change_scene("res://src/Test.tscn")


func _on_0_pressed():
	$text.text += "0"


func _on_9_pressed():
	$text.text += "9"


func _on_8_pressed():
	$text.text += "8"


func _on_7_pressed():
	$text.text += "7"


func _on_6_pressed():
	$text.text += "6"


func _on_5_pressed():
	$text.text += "5"


func _on_4_pressed():
	$text.text += "4"


func _on_pw_pressed():
	pressed += 1
