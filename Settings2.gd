extends Popup

onready var sound_off = load("res://assets/sound_off.png")
onready var sound_on = load("res://assets/sound_on.png")
var min_volume = -30
var vec = Vector2(52, 52)

func _ready():
#	pass
	$Sound.visible = true
	$Other.visible = false
	
	if Global._settings["joystick"]["type"] == 1:
		$Other/selected.position = $Other/joy2.position + vec
	elif Global._settings["joystick"]["type"] == 2:
		$Other/selected.position = $Other/joy3.position + vec

func _on_sound_button_pressed():
	$Sound.visible = true
	$Other.visible = false

func _on_other_button_pressed():
	$Sound.visible = false
	$Other.visible = true

func _on_joy1_pressed():
	Global._settings["joystick"]["type"] = 0
	Global.save_settings()
	$Other/selected.position = $Other/joy1.position + vec

func _on_joy2_pressed():
	Global._settings["joystick"]["type"] = 1
	Global.save_settings()
	$Other/selected.position = $Other/joy2.position + vec


func _on_joy3_pressed():
	Global._settings["joystick"]["type"] = 2
	Global.save_settings()
	$Other/selected.position = $Other/joy3.position + vec
