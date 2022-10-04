extends Node2D

onready var sound_off = load("res://assets/sound_off.png")
onready var sound_on = load("res://assets/sound_on.png")
var min_volume = -30

func _ready():
#	pass
#	if Global._settings["joystick"] == 1:
#		$Other/selected.position = $Other/joy2.position
#	elif Global._settings["joystick"] == 2:
#		$Other/selected.position = $Other/joy3.position
#	pass
	$HSlider.value = Global._settings["audio"]["master_volume"]
	$MusicSlider.value = Global._settings["audio"]["music_volume"]
	$sfxSlider.value = Global._settings["audio"]["sfx_volume"]

	if Global._settings["audio"]["master_mute"]:
		$mute_toggle.normal = sound_off

	if Global._settings["audio"]["music_mute"]:
		$mute_music.normal = sound_off

	if Global._settings["audio"]["sfx_mute"]:
		$mute_sfx.normal = sound_off

func _on_mute_toggle_pressed():
	if Global._settings["audio"]["master_mute"] == false:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80)
		$mute_toggle.normal = sound_off
		Global._settings["audio"]["master_mute"] = true
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), Global._settings["audio"]["master_volume"])
		$mute_toggle.normal = sound_on
		Global._settings["audio"]["master_mute"] = false
	Global.save_settings()
	
func _on_HSlider_value_changed(value):
	
	if value <= min_volume:		
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80)
		$mute_toggle.normal = sound_off	
		Global._settings["audio"]["master_volume"] = -80
	else:
		if !Global._settings["audio"]["master_mute"]:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
			$mute_toggle.normal = sound_on
#		Global._settings["audio"]["master_mute"] = false
		Global._settings["audio"]["master_volume"] = value
	Global.save_settings()

func _on_mute_music_pressed():
	if Global._settings["audio"]["music_mute"] == false:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -80)
		$mute_music.normal = sound_off
		Global._settings["audio"]["music_mute"] = true
		
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), Global._settings["audio"]["music_volume"])
		$mute_music.normal = sound_on
		Global._settings["audio"]["music_mute"] = false
	Global.save_settings()		
	
func _on_mute_sfx_pressed():
	if Global._settings["audio"]["sfx_mute"] == false:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), -80)
		$mute_sfx.normal = sound_off
		Global._settings["audio"]["sfx_mute"] = true
		
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), Global._settings["audio"]["sfx_volume"])
		$mute_sfx.normal = sound_on
#		$SFX2.play()
		Global._settings["audio"]["sfx_mute"] = false
	Global.save_settings()
	
func _on_MusicSlider_value_changed(value):
	
	
	if value <= min_volume:		
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -80)
		$mute_music.normal = sound_off
		Global._settings["audio"]["music_volume"] = -80	
	else:
		if !Global._settings["audio"]["music_mute"]:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
			$mute_music.normal = sound_on
		Global._settings["audio"]["music_volume"] = value	
#		Global._settings["audio"]["music_mute"] = false
	Global.save_settings()

func _on_sfxSlider_value_changed(value):
	
#	$SFX2.play()
	if value <= min_volume:		
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), -80)
		$mute_sfx.normal = sound_off
		Global._settings["audio"]["sfx_volume"] = -80	
	else:
		if !Global._settings["audio"]["sfx_mute"]:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)
			$mute_sfx.normal = sound_on	
		Global._settings["audio"]["sfx_volume"] = value
#		Global._settings["audio"]["sfx_mute"] = false
	Global.save_settings()


#func _on_sound_button_pressed():
#	$Sound.visible = true
#	$Other.visible = false
#
#func _on_other_button_pressed():
#	$Sound.visible = false
#	$Other.visible = true


#func _on_joy1_pressed():
#	Global._settings["joystick"] = 0
#	Global.save_data()
#	$Other/selected.position = $Other/joy1.position
#
#func _on_joy2_pressed():
#	Global._settings["joystick"] = 1
#	Global.save_data()
#	$Other/selected.position = $Other/joy2.position
#
#
#func _on_joy3_pressed():
#	Global._settings["joystick"] = 2
#	Global.save_data()
#	$Other/selected.position = $Other/joy3.position
