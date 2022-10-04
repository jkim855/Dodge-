extends Node2D

onready var Level = get_parent().get_parent()
var speed = 2
#var max_speed = 3
var max_speed = 3
var max_laser_time = 0.65 # 0.75
var laser_warning = 0.8
var laser_dur = 0.45
var max_laser_dur = 0.15
var max_laser_warning = 0.4 #0.5
var left = false
onready var random_laser_scene = load("res://src/random_laser.tscn")
onready var random_laser_timer = get_node("../../random_laser")
var resume = false

func _ready():
#	appear()
	#rig
#	left = true
	modulate.a = 0
#	set_physics_process(false)
	
func start():
	yield(get_tree().create_timer(1.0), "timeout")
	$fade_timer.start()
	$Timer.start()
	
func stop():
	if !Global.spin_pattern:
		return
	Global.spin_pattern = false
	get_node("Up/CollisionShape2D").disabled = true
	get_node("Down/CollisionShape2D2").disabled = true
	$fo_timer.start()
	for child in get_node("../../pattern_objects").get_children():
		child.queue_free()
	
	if resume:
		return
	
	if random_laser_timer.wait_time - 0.3 >= max_laser_time:
		random_laser_timer.wait_time -= 0.3
	else:
		random_laser_timer.wait_time = max_laser_time
	
	if laser_warning - 0.2 >= max_laser_warning:
		laser_warning -= 0.2
	else:
		laser_warning = max_laser_warning
		
	if laser_dur - 0.15 >= 0.15:
		laser_dur -= 0.15
	else:
		laser_dur = 0.15
		
func fade_out():
	if modulate.a > 0:
		modulate.a -= 0.1
	else:
		$fo_timer.stop()
		if speed + 1 <= max_speed:
			speed += 1
		else:
			speed = max_speed
		
	
func fade_in():
	if modulate.a < 1:
		modulate.a += 0.05
	else:
		$fade_timer.stop()
		
		get_node("Up/CollisionShape2D").disabled = false
		get_node("Down/CollisionShape2D2").disabled = false
#		get_node("../Timer").stop()

func _on_Timer_timeout():
	if left:
		rotation_degrees += 1 * speed	
	else:
		rotation_degrees -= 1 * speed

func _on_Down_body_entered(_body):
	Level.calc()

func _on_Up_body_entered(_body):
	Level.calc()

func _on_fade_timer_timeout():
	fade_in()


#func _on_speed_timeout():
#	if speed + 0.15 <= max_speed:
#		speed += 0.15
#	else:
#		speed = max_speed


func _on_fo_timer_timeout():
	fade_out()

func set_max_speed():
	speed = max_speed
	laser_dur = max_laser_dur
	laser_warning = max_laser_warning

func _on_random_laser_timeout():
	var random_laser_instance = random_laser_scene.instance()
#	get_node("Background2/random_laser").add_child(random_laser_instance)
#	$pattern_objects.add_child(random_laser_instance)
	get_node("../../pattern_objects").add_child(random_laser_instance)
#	random_laser_instance.laser_dur = laser_dur
#	random_laser_instance.laser_warning = laser_warning
	random_laser_timer.start()

func inc_laser():
	if random_laser_timer.wait_time - 0.3 >= max_laser_time:
		random_laser_timer.wait_time -= 0.3
	else:
		random_laser_timer.wait_time = max_laser_time
	
	if laser_warning - 0.2 >= max_laser_warning:
		laser_warning -= 0.2
	else:
		laser_warning = max_laser_warning
		
	if laser_dur - 0.15 >= 0.15:
		laser_dur -= 0.15
	else:
		laser_dur = 0.15
