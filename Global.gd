extends Node

var boosted = null
var first_laser_finished = false
var skip = false
var laser_finished = true
var pressed = []
var tutorial
var Start_Tutorial = false

const save_path_skin = "user://skin.save"
var score = ""
var move_vector = Vector2(0, 0)
var laser_pattern = false
var square_pattern = false
var wall_pattern = false
var spin_pattern = false

var skins_path = "res://assets/skins/"
var skin
var skins 
var skin_index = 0
var wall_speed = 14
var test = false
var wall_count = 1

var laser_duration = 0.4
const SAVE_DIR = "user://saves/"
var save_path = SAVE_DIR + "save.dat"
var Settings = load("res://src/Settings.gd")
var testing
var max_speed = false
var ability
var item

var _config_file = ConfigFile.new()
var _settings = {
	"audio": {
		"master_mute" : false,
		"music_mute" : false,
		"sfx_mute" : false,
		"master_volume" : 0,
		"music_volume" : 0,
		"sfx_volume" : 0
	},
	"level" : {
		"laser" : true,
		"square" : true,
		"moving" : true,
		"spin" : true,
		"max_speed" : false,
	},
	"joystick" : {
		"type" : 0
	},
}

var data = {
	"admin" : false,
	"high_score" : 0.0,
	"money" : 0,
	"no_ads" : false,
	"multiplier" : false,
	"skins" : {
		"selected" : 0,
		"unlocked" : [0]
	},
	"abilities" : {
		"selected" : null,
		"unlocked" : []	
	},
	"items" : {
		"selected" : null,
		"unlocked" : []
	},
	"watched" : null,
	"levels" : {
		
	},
	"next_alert" : null,

}

var test_room = false

func _ready():

	skins = list_files_in_directory(skins_path)
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
		
	load_data()
	load_settings()
	set_sound()
	ability = data["abilities"]["selected"]
	item = data["items"]["selected"]
	print(ability)
#	print(data)
	print(_settings)
	print()
	print("Save:")
	print(data)
#	skins = []
#	skins.append(load("res://assets/skins/player.png"))
#	skins.append(load("res://assets/skins/player2.png"))
#	skins.append(load("res://assets/skins/player3.png"))
#	skins.append(load("res://assets/skins/player4.png"))
#	skins.append(load("res://assets/skins/player5.png"))
#	skins.append(load("res://assets/skins/player6.png"))
#	skins.append(load("res://assets/skins/zspecial.png"))
#	skins.append(Color(0,1,0))
#	skins.append(Color(1,0,0))
#	skins.append(Color(0,0,1))

#	print(skins)
	
#	skin = skins[skin_index]
	
func set_sound():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), _settings["audio"]["master_volume"])
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), _settings["audio"]["music_volume"])
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), _settings["audio"]["sfx_volume"])
	if _settings["audio"]["master_mute"]:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80)

	if _settings["audio"]["music_mute"]:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -80)
		
	if _settings["audio"]["sfx_mute"]:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), -80)


func load_settings():
	var error = _config_file.load(SAVE_DIR + "config.cfg")
	if error != OK:
		print("Error loading settings:")
		print(error)
		return []
	for section in _settings.keys():
		for key in _settings[section]:
			_settings[section][key] = _config_file.get_value(section, key, null)
		
	
func save_settings():
	for section in _settings.keys():
		for key in _settings[section]:
			_config_file.set_value(section, key, _settings[section][key])
	_config_file.save(SAVE_DIR + "config.cfg")

func set_score(num):
	score = num

func list_files_in_directory(path):
	var skins_list = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	var filename = dir.get_next()
	while (filename != ""):
		if filename.ends_with(".import"):
			filename = filename.replace('.import', '') # <--- remove the .import
			if filename.ends_with(".png"):
				skins_list.append(load(path+filename))
		filename = dir.get_next()

	dir.list_dir_end()

	return skins_list

func load_data():
	
	var file = File.new()
#	var error = file.open(save_path, File.READ)
	var error = file.open_encrypted_with_pass(save_path, File.READ, "dodgeistaken")
#	if file.file_exists(save_path):
	if error == OK:
		var data_temp = file.get_var()
		for key in data:
			if not key in data_temp:
				data_temp[key] = data[key]
		data = data_temp
		file.close()
		print("loaded")
	elif error == ERR_FILE_NOT_FOUND:
		error = file.open("user://savedata.save", File.READ)
		Start_Tutorial = true
		if error == OK:
			data["high_score"] = file.get_var()
			file.close()
			print("loaded from old file")
			return
		print("created")
	else:
		print("Error loading file:")
		print(error)
	
	

func save_data():
	data["abilities"]["selected"] = ability
	data["items"]["selected"] = item
	
	var file = File.new()
#	var error = file.open(save_path, File.WRITE)
	var error = file.open_encrypted_with_pass(save_path, File.WRITE, "dodgeistaken")
	if error == OK:
		file.store_var(data)
		file.close()
		print(data)
		print("saved")
	elif error == ERR_FILE_NOT_FOUND:
		print("error")
	else:
		print("Error saving file:")
		print(error)
