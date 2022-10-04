extends Node2D

var lives = 3
var time = 0.0
var interval = 15.0 #test
var laser_warning_time = 0.8
var square_warning_time = 2.0
onready var background = get_node("Background")
onready var timer_post = $Pattern_Cool_Post

onready var laser_scene = load("res://src/Laser.tscn")
onready var follow_laser_scene = load("res://src/Follow_Laser.tscn")
#onready var random_laser_scene = load("res://src/random_laser.tscn")

#onready var Squares = get_node("Squares")
onready var hpack_scene = load("res://src/Health_Pack.tscn")
#onready var wall_scene = load("res://src/Moving_Laser.tscn")
onready var wall_scene = load("res://src/Moving_Warning.tscn")
onready var square_scene = load("res://src/Square.tscn")
onready var wall_scene2 = load("res://src/Moving2.tscn")

var patterns = ["square", "moving", "spin"]
var walls_array = []

var test_patterns
var no_test_patterns
var test_patterns_rand

onready var player = get_node("Background2/Player")
onready var blood = load("res://src/Blood.tscn")
onready var Health = get_node("Touch_Buttons/Health")

var max_laser_time = 0.6
var max_follow_time = 0.5
var square_list
var square_pattern_no = 2
var laser_inc = 0.3
var square_inc = 0.5
var follow_laser_inc = 0.25
var max_square_int = 1
var square_hit_dur = 0.5
var max_square_hit_dur = 0.2
var square_blink_dur = 1
var max_square_blink_dur = 0.8
var max_wall_speed = 22
var max_wall_time = 2
var wall_time = 0.5
var max_wall_prep = 1.5
var wall_prep_dec = 0.5
var wall_speed_inc = 4
var multiple_walls
var saved_wall_time
#var max_wall_speed = 17
#var max_wall_time = 2.5
#var max_spin_speed = 55
#w
var wall_pattern_no = 1

var test = true
var test_array = ["square", "moving", "spin"]
onready var pattern_objects = get_node("pattern_objects")
#onready var Intro = get_node("../Intro")

func _ready():
	$boosts.visible = false
#	if Global.ability == null:
#		get_node("Touch_Buttons/Controls/Float").visible = false
	if Global.test_room:
		player.super_invincible = true
#		$Background2/All.visible = true
		#back off/on
#		test_array = []
#		set_physics_process(false)
		$Touch_Buttons/Controls.modulate.a = 0
		$Touch_Buttons/Health.modulate.a = 0
		$CanvasLayer/Score.modulate.a = 0
		$Touch_Buttons/Controls/Pause.modulate.a = 0
	if Global.item == "heal":
		if Global.data["levels"]["heal"] == 1:
			$HPack_Timer.wait_time = $HPack_Timer.wait_time - 10
			$HPack_Timer.start()
		elif Global.data["levels"]["heal"] == 2:
			$HPack_Timer.wait_time = $HPack_Timer.wait_time - 20
			$HPack_Timer.start()
		elif Global.data["levels"]["heal"] == 3:
			$HPack_Timer.wait_time = $HPack_Timer.wait_time - 30
			$HPack_Timer.start()
	if Global.ability == "hook":
		print("disable")
		$hook_left/Bigger.disabled = false
		$hook_right/Bigger.disabled = false

#	Intro.load_reward()
	$Background2/All.visible = false
#	apply_test_values()
	time = 0.0
	$Black.visible = true
	$Fade_In.play("Fade_In")
	MusicController.get_child(0).playing = false
	
	
	
	if Global.testing:
		test_patterns = []
		if Global._settings["level"]["laser"]:
			test_patterns.append("laser")
		if Global._settings["level"]["square"]:
			test_patterns.append("square")
		if Global._settings["level"]["moving"]:
			test_patterns.append("moving")
		if Global._settings["level"]["spin"]:
			test_patterns.append("spin")
		
		#back on
		if Global.test_room:
#			pass
			test_patterns = ["laser"]
#			test_patterns = []
			
		no_test_patterns = test_patterns.size() #minus 1 for laser & minus 1 for array indexing
#		if "laser" in test_patterns:
#			no_test_patterns -= 1
		test_patterns_rand = [] + test_patterns
		if test_patterns.has("laser"):
			test_patterns_rand.erase("laser")
			no_test_patterns -= 1
		
		if Global.test_room:
			#back on/off
			set_medium_speed()
#			set_max_speed()
		
		elif Global._settings["level"]["max_speed"]:
			set_max_speed()
#			$HPack_Timer.set_wait_time(15)
			$HPack_Timer.start()
	
	if Global.testing:
		print("Testing")
		print(test_patterns_rand)
		print("number of patterns exc. laser: ", no_test_patterns)
	else:
		print("Playing")
		print(patterns)
		print("number of patterns exc. laser: ", patterns.size()-1)
	
	
#	yield(get_tree().create_timer(2), "timeout")
	
	if !Global.testing or "laser" in test_patterns:
		
		Global.laser_pattern = true
		$Laser_Timer.start()
		$Follow_Laser_Timer.start()

	else:
#		background.fade_out()
#		background.set_breathe(false)
		set_rand_pattern()
	
	

#	if Global.test: #"special button" for testing moving laser
#		interval = 2000
#		$First_Wall.start()
#		$Laser_Timer.stop()
#		$Follow_Laser_Timer.stop()
#		background.fade_out_vertical()

#func apply_test_values():
#	print(test.return_values())
#	pass
func generate_random(n1, n2):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return rng.randi_range(n1, n2)

func _physics_process(delta):
	#test
	if Input.is_action_just_pressed("die"):
		countdown()
	time += delta
	
	if time > interval:
		time -= interval
		
		next_pattern()

func next_pattern():
#	if test and !Global.testing:
#	if Global.spin_pattern:
#		end_spin_pattern()
#	else:
#		start_spin_pattern()
#	return
#	print(1)
	if test:
#		print(2)
		if Global.testing:
			if test_patterns.size() == 0:
				return
#			print(3)
#			print(test_array)
#			print(test_patterns_rand, no_test_patterns)
#			print(test_patterns)
#			if !test_patterns_rand or no_test_patterns == 1:
			if test_patterns.size() == 1:
				if test_patterns[0] == "laser":
					end_laser_pattern()
					start_laser_pattern()
				elif test_patterns[0] == "square":
					end_square_pattern()
					start_square_pattern()
				elif test_patterns[0] == "spin":
#					end_spin_pattern()
#					start_spin_pattern()
					pass
				elif test_patterns[0] == "moving":
					$Wall_Timer.stop()
					start_moving_laser_pattern()
				
			else:
				if Global.laser_pattern:
					
					set_rand_pattern()
				else:
					all_patterns_off()
					start_laser_pattern()
			return
			
		if Global.laser_pattern:
#			print(2)
			end_laser_pattern()
			print(test_array)
			if test_array == []:
				test_array = ["square", "moving", "spin"]
#				test = false
#				set_rand_pattern()
#				return
			var index = generate_random(0, len(test_array)-1)
#			var pattern = test_array.pop_front()
			var pattern = test_array.pop_at(index)
			if pattern == "moving":
				print("accepted")
				start_moving_laser_pattern()
			elif pattern == "square":
				start_square_pattern()
			elif pattern == "spin":
				start_spin_pattern()
		else:
#			print(3)
			all_patterns_off()
			if !Global.testing or "laser" in test_patterns:
				start_laser_pattern()
		return
		
	if Global.laser_pattern == true:
		if !Global.testing or test_patterns_rand:
			end_laser_pattern()
	#				background.fade_out()
	#				background.set_breathe(false)
			set_rand_pattern()
		
	else:
		
		if Global.square_pattern == true:
			#change - fix to change behaviour from second square pattern
	#				if Squares.pattern_no < 2:
	#					Squares.pattern_no += 1
			end_square_pattern()
		
		if Global.spin_pattern == true:
			end_spin_pattern()
		
		if Global.testing and !("laser" in test_patterns):
			set_rand_pattern()
			
		else:
			start_laser_pattern()

func end_laser_pattern():
	$Laser_Timer.stop()
	$Follow_Laser_Timer.stop()
	Global.laser_pattern = false

func start_laser_pattern():
	
	background.fade_in()
	background.fade_in_vertical()
	Global.laser_pattern = true
#	Global.square_pattern = false
#	Global.wall_pattern = false
#	$Wall_Timer.stop()
	
	if $Laser_Timer.wait_time - laser_inc > max_laser_time:
		$Laser_Timer.set_wait_time($Laser_Timer.wait_time-laser_inc)
	else:
		$Laser_Timer.set_wait_time(max_laser_time)
		
	if $Follow_Laser_Timer.wait_time - follow_laser_inc > max_follow_time:
		$Follow_Laser_Timer.set_wait_time($Follow_Laser_Timer.wait_time-follow_laser_inc)
		Global.laser_duration -= 0.04
	else:
		$Follow_Laser_Timer.set_wait_time(max_follow_time)
		Global.laser_duration = 0.2

	timer_post.start()
	if timer_post.wait_time - 0.4 >= 1.8:
		timer_post.wait_time -= 0.4
	else:
		timer_post.wait_time = 1.8

func end_square_pattern():
	Global.square_pattern = false
	if square_pattern_no < 4:
		square_pattern_no += 1
	if $Square_Timer.wait_time - square_inc >= max_square_int:
		$Square_Timer.set_wait_time($Square_Timer.wait_time-laser_inc)
	else:
		$Square_Timer.set_wait_time(max_square_int)
	if square_hit_dur - 0.15 >= max_square_hit_dur:
		square_hit_dur -= 0.15
	else:
		square_hit_dur = max_square_hit_dur
	
	if square_blink_dur - 0.1 >= max_square_blink_dur:
		square_blink_dur -= 0.1
	else:
		square_blink_dur = max_square_blink_dur
	$Square_Timer.stop()

func set_medium_speed():
	Global.laser_duration = 0.32
	$Follow_Laser_Timer.set_wait_time(1.0)
	$Laser_Timer.set_wait_time(1.5)

func set_max_speed():
	square_pattern_no = 4
	Global.laser_duration = 0.2
	$Follow_Laser_Timer.set_wait_time(max_follow_time)
	$Laser_Timer.set_wait_time(max_laser_time)
	timer_post.wait_time = 1.8
	#back on
	$First_Square.wait_time = 1.8
	$Background2/Laser.set_max_speed()
	$First_Wall.wait_time = max_wall_prep
	$random_laser.wait_time = get_node("Background2/Laser").max_laser_time
#	get_node("Background2/Laser").laser_dur = 0.2
#	get_node("Background2/Laser").laser_warning = 0.5
#	Global.laser_duration = 0.5
#	$Follow_Laser_Timer.set_wait_time(1.5)
#	$Laser_Timer.set_wait_time(1.5)
	$Square_Timer.set_wait_time(max_square_int)
	square_hit_dur = max_square_hit_dur
	square_blink_dur = max_square_blink_dur
	$Wall_Timer.set_wait_time(max_wall_time)
	Global.wall_speed = max_wall_speed


func start_square_pattern():
	Global.square_pattern = true
	background.fade_out()
	background.set_breathe(false)
	$First_Square.start()
	if $First_Square.wait_time - 0.6 >= 1.8:
		$First_Square.wait_time -= 0.6
	else:
		$First_Square.wait_time = 1.8
#	if square_pattern_no >= 4:
#		$Square_Timer.wait_time = 1.5
#		square_hit_dur = 0.35
#		square_blink_dur = 0.95
	
func start_moving_laser_pattern():
	background.fade_out_vertical()
	Global.wall_pattern = true
	$First_Wall.start()

func set_rand_pattern():
	all_patterns_off()
	
	
		
	if Global.testing:
		if no_test_patterns == 0:
			return
		var random = generate_random(0,no_test_patterns-1) #test
		
		
		print("pattern: ", test_patterns_rand[random])
				
		if test_patterns_rand[random] == "square":
			start_square_pattern()
		
		elif test_patterns_rand[random] == "moving":
			start_moving_laser_pattern()
		
		elif test_patterns_rand[random] == "spin":
			start_spin_pattern()
	
	else:
		print("[indicator I placed before]")
		var random = generate_random(0,patterns.size()-1) #test
			
		print("pattern: ", patterns[random])
				
		if patterns[random] == "square":
			background.fade_out()
			background.set_breathe(false)
			$First_Square.start()
		
		elif patterns[random] == "moving":
			background.fade_out_vertical()
			Global.wall_pattern = true
			$First_Wall.start()
			#@@
		elif patterns[random] == "spin":
			start_spin_pattern()

func start_spin_pattern():
	var direction = generate_random(0, 1)
	#rig
	#back off
#	direction = 1

	if direction == 0:
		$Background2/Laser.left = true
		$Area2D/Bigger.position.x = 72
		$Background2/Timer2.start()
	else:
		$Background2/Laser.left = false
		$Area2D/Bigger.position.x = 1050
		$Background2/Timer.start()
	$Background.visible = false
	
	Global.spin_pattern = true
	$Background2/Laser.start()
	$Background2/All.visible = true
	yield(get_tree().create_timer(0.8), "timeout")
	$Area2D/Bigger.disabled = false
	$random_laser.start()

func end_spin_pattern():
#	if Global.testing and test_patterns == ["spin"]:
#		return
	$Background.visible = true
	$Background2/Timer.stop()
	$Background2/Timer2.stop()
	$Background2/Tiles.modulate.a = 0
	$Background2/Tiles_Left.modulate.a = 0
	
	$Background2/Laser.stop()
	$Background2/All.visible = false
	$Area2D/Bigger.disabled = true
	$random_laser.stop()

func all_patterns_off():
#	print("all off")
	Global.laser_pattern = false
	
	end_spin_pattern()
	$Laser_Timer.stop()
	$Follow_Laser_Timer.stop()
	$Wall_Timer.stop()
	if Global.wall_pattern:
		wall_pattern_no += 1
	Global.wall_pattern = false
	
	if Global.square_pattern:
		end_square_pattern()

func start_laser():
	if Global.laser_pattern:
		$Laser_Timer.start()
		$Follow_Laser_Timer.start()
		
	else:
		pass

#SET DIFFERENT warning times for laser and squares
#	if time + laser_warning_time > interval:
#		Global.laser_pattern = false
#
#	if time + square_warning_time > interval:
#		Global.square_pattern = false

func add_life():
	if lives < 4:
		lives += 1

func calc():
	
	
	if player.invincible == false and player.super_invincible == false:
#		var blood_instance = blood.instance()
#		get_tree().current_scene.add_child(blood_instance)	
#		blood_instance.global_position = player.global_position
		if player.guarding:
			player.destroy_guard()
			Health.guard_inv()
			return
			
		Health.set_life()
		if !Global.test_room:
			lives -= 1
		if lives == 0:
			lives = 3

			if $Death_Popup.revived < 2:
				countdown()
			else:
				$Music.stop()
				get_tree().paused = true
				yield(get_tree().create_timer(0.5), "timeout")
				die()

func countdown():
	get_node("Death_Popup").show_popup()
	

func die():
	player.get_node("PlayerSprite").material.set_shader_param("whiten", false)
	var score = float(Global.score)
	if score > Global.data["high_score"]:
		Global.data["high_score"] = score
	Transition.game_over()
	
	Global.save_data()
	Global.move_vector = Vector2.ZERO

func _on_Laser_Timer_timeout():
	var laser_instance = laser_scene.instance()
	pattern_objects.add_child(laser_instance)

#func midi_event(channel, event):
#	print("yes")
func _input(event):
#	#test
	if Input.is_action_just_pressed("S"):
		time = 0
		next_pattern()
#	if Input.is_action_just_pressed("Enter"):
#		if Global.test_room:
#			Global.test_room = false
#			get_tree().paused = false
#			get_tree().change_scene("res://src/Intro.tscn")
	
func _on_Follow_Laser_Timer_timeout():
	var follow_laser_instance = follow_laser_scene.instance()
	pattern_objects.add_child(follow_laser_instance)

func _on_HPack_Timer_timeout():
	var hpack_instance = hpack_scene.instance()
	add_child(hpack_instance)
	#adjust
#	if $HPack_Timer.wait_time > 15:
#		$HPack_Timer.set_wait_time($HPack_Timer.wait_time - 15)


func _on_Wall_Timer_timeout():
#	if $Wall_Timer.wait_time - 0.2 >= 1.5:
	#w
	create_wall_warning()
	
	#0.7
func create_wall_warning():
	
	if wall_pattern_no < 2:
		multiple_walls = false
		Global.wall_count = 1
		generate_wall()
	else:
		Global.wall_count = 2
		multiple_walls = true
		create_double_wall()
		$Wall_Timer.stop()
		return

#	else:
#		# 5% chance of being returned.
#		Global.wall_count = 3
#		multiple_walls = true

	

func generate_wall():
	var wall_instance = wall_scene.instance()
	pattern_objects.add_child(wall_instance)

func create_double_wall():
	$double_wall.start()

func _on_First_Wall_timeout():
	$Wall_Timer.start()
	create_wall_warning()
#	Global.wall_speed += 0.5
	if $Wall_Timer.wait_time - wall_time >= max_wall_time:
		$Wall_Timer.set_wait_time($Wall_Timer.wait_time-wall_time)
	else:
		$Wall_Timer.set_wait_time(max_wall_time)
		
	if Global.wall_speed + wall_speed_inc <= max_wall_speed:
		Global.wall_speed += wall_speed_inc
	else:
		Global.wall_speed = max_wall_speed
	
	if $First_Wall.wait_time - wall_prep_dec >= max_wall_prep:
		$First_Wall.wait_time -= wall_prep_dec
	else:
		$First_Wall.wait_time = max_wall_prep

func _on_First_Square_timeout():

	Global.square_pattern = true
	$Square_Timer.start()
	make_squares()
	yield(get_tree().create_timer(square_blink_dur), "timeout")
	$Square.play()
#	if $Squares/Square_Timers/Cooldown.wait_time - 0.1 >= 0.3:
#		$Squares/Square_Timers/Cooldown.set_wait_time($Squares/Square_Timers/Cooldown.wait_time - 0.1)
#	else:
#		$Squares/Square_Timers/Cooldown.set_wait_time(0.3)

func _on_Square_Timer_timeout():
	make_squares()
	yield(get_tree().create_timer(square_blink_dur), "timeout")
	$Square.play()
	
func make_squares():
	square_list = []
	var row
	var column
	var square_sets = 1
#	if square_pattern_no >= 4:
#		square_sets = 3
	if square_pattern_no >= 2:
		square_sets = 2
	
	for _i in range(square_sets):
		
		while true:
			row = generate_random(1,3)
			column = generate_random(1,5)
#			print(square_list)
			if !(Vector2(column, row) in square_list):
				break
				
		var _result = make_square(Vector2(column, row))
	#	if(result is GDScriptFunctionState and result.is_valid()):
	#		yield(result, "completed")
		add_more_squares(column, row)

	
func make_square(col_row):
	var square_instance = square_scene.instance()
	var column = col_row[0]
	var row = col_row[1]
	square_instance.set_position(Vector2((column-1)*155, (row-1)*150))
	pattern_objects.add_child(square_instance)
	square_list.append(col_row)

func add_more_squares(col, row):
#	print(Vector2(col, row))
	var pos = Vector2(col, row)
	var iter = 3
	if square_pattern_no >= 3:
		iter = 4
	
	for _i in range(iter):
		var direction = []
		if col > 1 and !(Vector2(col-1, row) in square_list):
			direction.append("W")

		if col < 5 and !(Vector2(col+1, row) in square_list):
			direction.append("E")

		if row > 1 and !(Vector2(col, row-1) in square_list):
			direction.append("N")

		if row < 3 and !(Vector2(col, row+1) in square_list):
			direction.append("S")

		if len(direction) > 0:
			var dir = direction[generate_random(0, len(direction)-1)]
			if dir == "W":
				pos = Vector2(col-1, row)
			elif dir == "E":
				pos = Vector2(col+1, row)
			elif dir == "N":
				pos = Vector2(col, row-1)
			else:
				pos = Vector2(col, row+1)

			make_square(pos)

		
#		if pos.x and pos.y:
		col = pos.x
		row = pos.y
#		else:
#			break

func _on_Intro_pressed():
	Global.move_vector = Vector2.ZERO
	get_tree().change_scene("res://src/Intro.tscn")


func _on_Pattern_Cool_Post_timeout():
	start_laser()

func create_wall(pos):
	var wall_instance = wall_scene2.instance()
	
	if pos == 1:
		wall_instance.get_node("Up").queue_free()
		wall_instance.position.y -= 150
	elif pos == 3:
		wall_instance.get_node("Down").queue_free()
		wall_instance.position.y += 150
	
	if !multiple_walls:
		pattern_objects.add_child(wall_instance)
		return
	else:
		walls_array.append(wall_instance)
		
	if Global.wall_count == 0:
		Global.wall_count = 2
		create_consecutive_wall()
		
		multiple_walls = false
		$double_wall.stop()
#		$Wall_Timer.start()


func create_consecutive_wall():
	var wall = walls_array.pop_front()
	pattern_objects.add_child(wall)

func _on_double_wall_timeout():
	generate_wall()

func start_wall_timer():
#	saved_wall_time = $Wall_Timer.wait_time
#	$Wall_Timer.wait_time = 0.1
	$Wall_Timer.start()
#	$Wall_Timer.wait_time = saved_wall_time
#	create_wall_warning()


func _on_boost_timeout():
	if Global.data["high_score"] >= 90:
		if !$boosts.visible:
			$boosts.visible = true
			if Global.data["high_score"] < 180:
				get_node("boosts/120").visible = false
				get_node("boosts/60").global_position.x = 510
			$boost.start()
		else:
			$boosts.visible = false
		
func set_laser(num):
	if $Laser_Timer.wait_time - laser_inc * num > max_laser_time:
		$Laser_Timer.set_wait_time($Laser_Timer.wait_time-laser_inc*num)
	else:
		$Laser_Timer.set_wait_time(max_laser_time)
		
	if $Follow_Laser_Timer.wait_time - follow_laser_inc * num > max_follow_time:
		$Follow_Laser_Timer.set_wait_time($Follow_Laser_Timer.wait_time-follow_laser_inc * num)
		Global.laser_duration -= 0.04 * num
	else:
		$Follow_Laser_Timer.set_wait_time(max_follow_time)
		Global.laser_duration = 0.2

func set_square():
	if square_pattern_no < 4:
		square_pattern_no += 1
	if $Square_Timer.wait_time - square_inc >= max_square_int:
		$Square_Timer.set_wait_time($Square_Timer.wait_time-laser_inc)
	else:
		$Square_Timer.set_wait_time(max_square_int)
	if square_hit_dur - 0.15 >= max_square_hit_dur:
		square_hit_dur -= 0.15
	else:
		square_hit_dur = max_square_hit_dur
	
	if square_blink_dur - 0.1 >= max_square_blink_dur:
		square_blink_dur -= 0.1
	else:
		square_blink_dur = max_square_blink_dur

func _on_60_pressed():
	Global.boosted = 90
	$CanvasLayer/Score.time += 90
	$boosts.visible = false
	$boost.stop()
	for child in get_node("pattern_objects").get_children():
		child.queue_free()
	
	set_laser(2)
	set_square()
	set_wall()
	set_spin()
	
func _on_120_pressed():
	Global.boosted = 180
	$CanvasLayer/Score.time += 180
	$boosts.visible = false
	$boost.stop()
	for child in get_node("pattern_objects").get_children():
		child.queue_free()
	set_laser(4)
	set_square()
	set_square()
	set_wall()
	set_wall()
	set_spin()
	set_spin()

func set_spin():
	$Background2/Laser.speed += 1
	$Background2/Laser.inc_laser()

func set_wall():
	if $Wall_Timer.wait_time - wall_time >= max_wall_time:
		$Wall_Timer.set_wait_time($Wall_Timer.wait_time-wall_time)
	else:
		$Wall_Timer.set_wait_time(max_wall_time)
		
	if Global.wall_speed + wall_speed_inc <= max_wall_speed:
		Global.wall_speed += wall_speed_inc
	else:
		Global.wall_speed = max_wall_speed
	
	if $First_Wall.wait_time - wall_prep_dec >= max_wall_prep:
		$First_Wall.wait_time -= wall_prep_dec
	else:
		$First_Wall.wait_time = max_wall_prep
