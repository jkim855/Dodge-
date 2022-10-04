extends RayCast2D

onready var timer_warning = get_node("Timer_Warning")
onready var timer_ray = get_node("Timer_Ray")
onready var timer_disappear = get_node("Timer_Disappear")
onready var timer_resume = get_node("Timer_Resume")
onready var appear_timer = $Appear_Timer

onready var line = $Line2D
onready var warning = $Warning
onready var rayCast2D = $RayCast2D

onready var player = get_node("../Player")
onready var blood = load("res://src/Blood.tscn")
	
onready var dash = $Dash

onready var xLimit = 1130.0
onready var yLimit = 660.0

onready var Health = get_node("../Touch_Buttons/Health")
onready var Level = get_parent()

func _process(delta):
	start_pattern()
	
func _physics_process(delta):
	var space_state = get_world_2d().direct_space_state

	var result = space_state.intersect_ray(line.points[0], line.points[1], [self], 1)

	if result and result.collider.name == "Player" and player.invincible == false:
		
		var blood_instance = blood.instance()
		get_tree().current_scene.add_child(blood_instance)	
		blood_instance.global_position = player.global_position
		Health.set_life()
		Level.calc()
		
func _ready():
	set_process(false)
	set_physics_process(false)
	timer_warning.connect("timeout", self, "warning")
	$first_timer.start()
	line.points[0] = Vector2.ZERO
	line.points[1] = Vector2.ZERO
	warning.points[0] = Vector2.ZERO
	warning.points[1] = Vector2.ZERO
	
func _on_first_timer_timeout():
	start_pattern()
	
func start_pattern():
	if Global.laser_pattern:
		timer_warning.start()
		set_process(false)
	else:
		set_process(true)
		
func appear():
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 0, 10.0, 0.2)
	$Tween.start()

func disappear():
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 10.0, 0, 0.1)
	$Tween.start() 

func ray_disappear():
	disappear()
	timer_disappear.stop()
#	timer_warning.set_wait_time(timer_warning.wait_time - int(Global.score) * 0.005)
	timer_warning.set_wait_time(timer_warning.wait_time - 0.05)
	start_pattern()

	line.points[0] = Vector2.ZERO
	line.points[1] = Vector2.ZERO
	
func check_collision():
	set_physics_process(true)
	timer_disappear.set_wait_time(0.4)
	timer_disappear.connect("timeout", self, "ray_disappear")
	timer_disappear.start()

func warning():
	visible = true
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var quadrant = rng.randi_range(1, 4)
	var rand_pos_x 
	var rand_pos_y 
	
	if quadrant == 1:
		rand_pos_x = 0.0
		rand_pos_y = rng.randf_range(0.0, yLimit)
	elif quadrant == 2:
		rand_pos_x = xLimit
		rand_pos_y = rng.randf_range(0.0, yLimit)
	elif quadrant == 3:		
		rand_pos_x = rng.randf_range(0.0, xLimit)
		rand_pos_y = 0.0
	else:
		rand_pos_x = rng.randf_range(0.0, xLimit)
		rand_pos_y = yLimit
		
	var oVec = Vector2(rand_pos_x, rand_pos_y)
	var dVec = get_node("../Player").get_global_position()

	var gradient = (dVec.y - oVec.y) / (dVec.x - oVec.x)

	warning.points[0] = oVec
	
	var x
	var y
	
	if quadrant == 1:
		x = xLimit
		y = gradient * (x - oVec.x) + oVec.y
	
	elif quadrant == 2:
		x = 0.0
		y = gradient * (x - oVec.x) + oVec.y
		
	elif quadrant == 3:
		y = yLimit	
		x = (y - oVec.y) / gradient + oVec.x
		
	else:
		y = 0.0
		x = (y - oVec.y) / gradient + oVec.x
	
	warning.points[1] = Vector2(x, y)

	timer_warning.stop()
	timer_ray.connect("timeout", self, "ray")
	timer_ray.start()

func ray():
	appear()
	
	line.points[0] = warning.points[0]
	line.points[1] = warning.points[1]
	warning.points[0] = Vector2.ZERO
	warning.points[1] = Vector2.ZERO
	
	timer_ray.stop()
	appear_timer.connect("timeout", self, "check_collision") 
	#waits until the red line tween completely appears before checking for collision
	appear_timer.start()
	
