extends Node2D

var alpha_down = true
var rotated
var rotating
onready var player = get_node("Player")
onready var Tiles = $Tiles
onready var Tiles_Left = $Tiles_Left
var paused = false

func _ready():
	Tiles.modulate.a = 0
	Tiles_Left.modulate.a = 0

func _on_Area2D_body_entered(_body):
	if !rotating:
		Global.move_vector = Vector2.ZERO
#		print("hit")
		if get_node("Laser").left:
			$rotate_left.start()
		else:
			$rotate_timer.start()
		
		rotated = 0
		get_tree().paused = true
		rotating = true
		player.velocity.y = 0
#		player.collision_layer = 0
		get_node("Player/Dash").delete_dash()
#		get_node("bg/Player/Dash").highlight_purple()
		for child in get_node("../pattern_objects").get_children():
			child.queue_free()


func _on_Timer_timeout():
	if not paused:
		blink_tiles()


func _on_rotate_timer_timeout():

	if rotated + 5 <= 90:
		rotation_degrees += 5
#		$View.rotation_degrees -= 5
#		rotation_degrees += 5
		rotated += 5
	else:
		$rotate_timer.stop()
		
#		player.collision_layer = 1
		var pos = $Player.position
		get_tree().paused = false
		player.move_up(pos)
		revert_tiles()
#		player.reset_velocity()
#		$bg/All.rotation_degrees -= 90
#		$bg/All.position = Vector2(649, 212)
		yield(get_tree().create_timer(0.1), "timeout")
		rotating = false
		
	
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

func blink_tiles_left():
	var Square = Tiles_Left

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

func revert_tiles():
#	Tiles.rotation_degrees -= 90
	if get_node("Laser").left:
		$All.rotation_degrees += 90
		$Laser.rotation_degrees += 90
		$Tiles.rotation_degrees += 90
		$Tiles_Left.rotation_degrees += 90
		$random_laser.rotation_degrees += 90
	else:
		$All.rotation_degrees -= 90
		$Laser.rotation_degrees -= 90
		$Tiles.rotation_degrees -= 90
		$Tiles_Left.rotation_degrees -= 90
		$random_laser.rotation_degrees -= 90
#	$bg/Tiles.position = Vector2(0, -2)
#	$bg/All.position = Vector2(-3, -1)
#func _on_Area2D_body_exited(body):
#	rotating = false


func _on_rotate_left_timeout():
	if rotated - 5 >= -90:
		rotation_degrees -= 5
#		$View.rotation_degrees -= 5
#		rotation_degrees += 5
		rotated -= 5
	else:
		$rotate_left.stop()
		
#		player.collision_layer = 1
		var pos = $Player.position
		get_tree().paused = false
		player.move_up(pos)
		revert_tiles()
#		player.reset_velocity()
#		$bg/All.rotation_degrees -= 90
#		$bg/All.position = Vector2(649, 212)
		yield(get_tree().create_timer(0.1), "timeout")
		rotating = false


func _on_Timer2_timeout():
	if not paused:
		blink_tiles_left()
