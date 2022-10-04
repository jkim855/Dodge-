extends Node2D

onready var Level = load("res://src/Level.tscn")
var skins_path = "res://assets/skins/"
var skin_index
var skin
var skins
onready var sound_off = load("res://assets/sound_off.png")
onready var sound_on = load("res://assets/sound_on.png")
var min_volume = -30


func _ready():
	pass
	skins = Global.skins
	skin_index = Global.skin_index
	set_skin()

	$popups/sound_window.visible = true
#
	$popups/sound_window/HSlider.value = Global._settings["audio"]["master_volume"]
	$popups/sound_window/MusicSlider.value = Global._settings["audio"]["music_volume"]
	$popups/sound_window/sfxSlider.value = Global._settings["audio"]["sfx_volume"]

	if Global._settings["audio"]["master_mute"]:
		$popups/sound_window/mute_toggle.normal = sound_off

	if Global._settings["audio"]["music_mute"]:
		$popups/sound_window/mute_music.normal = sound_off

	if Global._settings["audio"]["sfx_mute"]:
		$popups/sound_window/mute_sfx.normal = sound_off

func _on_Back_pressed():
	if get_tree().change_scene("res://src/Main.tscn") != OK:
		print("Error during [Change Scene]")

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


func _on_TouchScreenButton2_pressed():
	if skin_index+1 < skins.size():
		skin_index += 1
	else:
		skin_index = 0
	set_skin()
	

func _on_TouchScreenButton_pressed():
	if skin_index-1 >= 0:
		skin_index -= 1
	else:
		skin_index = skins.size()-1
	set_skin()
	
func set_skin():
	skin = skins[skin_index]
	$popups/skins_window/Sprite.set_texture(skin)
	
#	if skin_index == skins.size()-1:
#		$popups/skins_window/Sprite.modulate = Color(1,1,1)
#		print("yes")
#	else:
#		$popups/skins_window/Sprite.modulate = Color(1.5,1.5,1.5)

func _on_TouchScreenButton3_pressed():
	Global.skin = skin
	Global.skin_index = skin_index


func _on_sound_button_pressed():
	hide_popups()
#	$popups/backgrounds_window.show()
	$popups/sound_window.visible = true


func _on_mute_toggle_pressed():
	if Global._settings["audio"]["master_mute"] == false:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80)
		$popups/sound_window/mute_toggle.normal = sound_off
		Global._settings["audio"]["master_mute"] = true
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), Global._settings["audio"]["master_volume"])
		$popups/sound_window/mute_toggle.normal = sound_on
		Global._settings["audio"]["master_mute"] = false
	Global.save_settings()
	
func _on_HSlider_value_changed(value):
	
	if value <= min_volume:		
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80)
		$popups/sound_window/mute_toggle.normal = sound_off	
		Global._settings["audio"]["master_volume"] = -80
	else:
		if !Global._settings["audio"]["master_mute"]:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
			$popups/sound_window/mute_toggle.normal = sound_on
#		Global._settings["audio"]["master_mute"] = false
		Global._settings["audio"]["master_volume"] = value
	Global.save_settings()

func _on_mute_music_pressed():
	if Global._settings["audio"]["music_mute"] == false:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -80)
		$popups/sound_window/mute_music.normal = sound_off
		Global._settings["audio"]["music_mute"] = true
		
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), Global._settings["audio"]["music_volume"])
		$popups/sound_window/mute_music.normal = sound_on
		Global._settings["audio"]["music_mute"] = false
	Global.save_settings()		
	
func _on_mute_sfx_pressed():
	if Global._settings["audio"]["sfx_mute"] == false:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), -80)
		$popups/sound_window/mute_sfx.normal = sound_off
		Global._settings["audio"]["sfx_mute"] = true
		
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), Global._settings["audio"]["sfx_volume"])
		$popups/sound_window/mute_sfx.normal = sound_on
		$SFX.play()
		Global._settings["audio"]["sfx_mute"] = false
	Global.save_settings()
	
func _on_MusicSlider_value_changed(value):
	
	
	if value <= min_volume:		
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -80)
		$popups/sound_window/mute_music.normal = sound_off
		Global._settings["audio"]["music_volume"] = -80	
	else:
		if !Global._settings["audio"]["music_mute"]:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
			$popups/sound_window/mute_music.normal = sound_on
		Global._settings["audio"]["music_volume"] = value	
#		Global._settings["audio"]["music_mute"] = false
	Global.save_settings()

func _on_sfxSlider_value_changed(value):
	
	$SFX.play()
	if value <= min_volume:		
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), -80)
		$popups/sound_window/mute_sfx.normal = sound_off
		Global._settings["audio"]["sfx_volume"] = -80	
	else:
		if !Global._settings["audio"]["sfx_mute"]:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)
			$popups/sound_window/mute_sfx.normal = sound_on	
		Global._settings["audio"]["sfx_volume"] = value
#		Global._settings["audio"]["sfx_mute"] = false
	Global.save_settings()

func _on_special_pressed():
	Global.test = true
	if get_tree().change_scene("res://src/Level.tscn") != OK:
		print("Error during [Change Scene]")

