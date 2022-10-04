extends RayCast2D

onready var timer_warning = get_node("Timer_Warning")
onready var timer_ray = get_node("Timer_Ray")
onready var timer_disappear = get_node("Timer_Disappear")
onready var timer_resume = get_node("Timer_Resume")
onready var appear_timer = $Appear_Timer

onready var line = $Line2D
onready var warning = $Warning

onready var xLimit = 1130.0
onready var yLimit = 660.0

onready var Level = get_parent().get_parent()

func _process(_delta):
	start_pattern()

func _physics_process(_delta):
	var space_state = get_world_2d().direct_space_state

	var result = space_state.intersect_ray(line.points[0], line.points[1], [self], 1)

	if result and result.collider.name == "Player":
		Level.calc()

func _ready():
	timer_disappear.set_wait_time(Global.laser_duration)
	set_process(false)
	set_physics_process(false)
	
	line.points[0] = Vector2.ZERO
	line.points[1] = Vector2.ZERO
	warning.points[0] = Vector2.ZERO
	warning.points[1] = Vector2.ZERO
	
	warning()

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
	$Tween.interpolate_property($Line2D, "width", 10.0, 0, 0.2)
	$Tween.start() 

func ray_disappear():
	disappear()
	queue_free()

func check_collision():
	set_physics_process(true)
	timer_disappear.connect("timeout", self, "ray_disappear")
	timer_disappear.start()
	
func warning():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var hor_or_ver = rng.randi_range(0, 1)
	var rand_pos_x 
	var rand_pos_y 
	var rand_pos_x2 
	var rand_pos_y2 
	if hor_or_ver == 0:
		rand_pos_x = 0.0
		rand_pos_y = rng.randf_range(0.0, yLimit)
		rand_pos_x2 = xLimit
		rand_pos_y2 = rng.randf_range(0.0, yLimit)
	else:
		rand_pos_x = rng.randf_range(0.0, xLimit)
		rand_pos_y = 0.0
		rand_pos_x2 = rng.randf_range(0.0, xLimit)
		rand_pos_y2 = yLimit
	
	var oVec = Vector2(rand_pos_x, rand_pos_y)
	var dVec = Vector2(rand_pos_x2, rand_pos_y2)

	#test - laser through middle
#	oVec = Vector2(500, 0)
#	dVec = Vector2(500, 600)
	#test

	warning.points[0] = oVec
	warning.points[1] = dVec
	
	timer_ray.connect("timeout", self, "ray")
	timer_ray.start()
	

func ray():
	appear()
	$SFX.play()
	line.points[0] = warning.points[0]
	line.points[1] = warning.points[1]
	warning.points[0] = Vector2.ZERO
	warning.points[1] = Vector2.ZERO
	
	timer_ray.stop()
	appear_timer.connect("timeout", self, "check_collision") 
	#waits until the red line tween completely appears before checking for collision
	appear_timer.start()
	
	


