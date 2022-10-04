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

onready var Squares = get_node("Squares")
onready var hpack_scene = load("res://src/Health_Pack.tscn")
onready var wall_scene = load("res://src/Moving_Laser.tscn")
onready var square_scene = load("res://src/Square.tscn")

var patterns = ["square", "moving"]

var test_patterns
var no_test_patterns
var test_patterns_rand

onready var player = get_node("bg/Player")
onready var blood = load("res://src/Blood.tscn")
onready var Health = get_node("Touch_Buttons/Health")

var square_list
var square_pattern_no = 1

var alpha_down = true
var rotated
var rotating
onready var Tiles = $bg/Tiles

func _ready():
	Tiles.modulate.a = 0

func add_life():
	if lives < 4:
		lives += 1

func calc():
	if player.invincible == false and player.super_invincible == false:
#		var blood_instance = blood.instance()
#		get_tree().current_scene.add_child(blood_instance)	
#		blood_instance.global_position = player.global_position
		Health.set_life()
		lives -= 1
		if lives == 0:
			lives = 3
			countdown()

func countdown():
	get_node("Death_Popup").show_popup()
	

func die():
	var score = float(Global.score)
	if score > Global.data["high_score"]:
		Global.data["high_score"] = score
	Transition.game_over()
	Global.data["money"] += round(score)
	Global.save_data()
	Global.move_vector = Vector2.ZERO


func _on_Timer_timeout():
	blink_tiles()
	
func blink_tiles():
	var Square = Tiles

	if alpha_down:
#		Square.modulate.a -= 0.15
		Square.modulate.a -= 0.1
	else:
#		Square.modulate.a += 0.1
		Square.modulate.a += 0.1
		
	if Square.modulate.a <= 0:
		alpha_down = false
	elif Square.modulate.a >= 0.9:
		alpha_down = true


func _on_Area2D_body_entered(body):
	
	if !rotating:
#		print("hit")
		$rotate_timer.start()
		rotated = 0
		get_tree().paused = true
		rotating = true
#		player.collision_layer = 0
		get_node("bg/Player/Dash").delete_dash()
#		get_node("bg/Player/Dash").highlight_purple()
		

func _on_rotate_timer_timeout():
	if rotated + 5 <= 90:
		$bg.rotation_degrees += 5
#		$View.rotation_degrees -= 5
#		rotation_degrees += 5
		rotated += 5
	else:
		$rotate_timer.stop()
		
#		player.collision_layer = 1
		var pos = $bg/Player.position
		get_tree().paused = false
		player.move_up(pos)
		revert_tiles()
#		player.reset_velocity()
#		$bg/All.rotation_degrees -= 90
#		$bg/All.position = Vector2(649, 212)
		yield(get_tree().create_timer(0.1), "timeout")
		rotating = false
		
func revert_tiles():
#	Tiles.rotation_degrees -= 90
	$bg/All.rotation_degrees -= 90
	$bg/Laser.rotation_degrees -= 90
	$bg/Tiles.rotation_degrees -= 90
#	$bg/Tiles.position = Vector2(0, -2)
#	$bg/All.position = Vector2(-3, -1)
#func _on_Area2D_body_exited(body):
#	rotating = false
