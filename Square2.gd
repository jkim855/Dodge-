extends Node2D

onready var durTimer = $Square_Timers/Blink_Duration
onready var hitDurTimer = $Square_Timers/Hit_Duration
onready var blink_timer = $Square_Timers/Blink_Timer
onready var alpha_down = true
onready var Level = get_parent().get_parent()
onready var warning = false
onready var is_running = false
onready var Square = get_node("Square")

onready var Squares = []
var pattern_no = 1

func _ready():
	visible = true
#	Square.modulate.a = 0
#	print(Global.square_pattern)
	hitDurTimer.wait_time = get_node("../../").square_hit_dur
	durTimer.wait_time = get_node("../../").square_blink_dur
	set_physics_process(false)
	
	start_pattern()


func start_pattern():
		#double
		
#		for i in range(pattern_no):
#			var random_sq = get_child(generate_random(1, 15))
#			Squares.append(random_sq)
#			fill_squares_list(int(random_sq.name.substr(6)))
		
	start_dur_timer()
	is_running = true
	

func _physics_process(_delta):

	if Square.get_overlapping_bodies():
		if Square.get_overlapping_bodies()[0].name == "Player":
			Level.calc()

func generate_random(n1, n2):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return rng.randi_range(n1, n2)

func hitSquare():
	blink_timer.stop()
	set_physics_process(true)

#	get_node("../Square").play()
#	var s = []
#	for square in Squares:
#		s.append(square.name.substr(6))
#	print(s)
	
	Square.modulate = Color(1, 0, 0)
	Square.modulate.a += 0.25
	
	hitDurTimer.connect("timeout", self, "Reset")
	hitDurTimer.start()	

func Reset():
#	print(Squares)
	for Square in Squares:
		Square.modulate = Color(1, 1, 1)
		Square.modulate.a = 0
	Squares = []
	queue_free()
	
func start_dur_timer():

	blink_timer.start()
	durTimer.start()
	durTimer.connect("timeout", self, "hitSquare")	
	
func blink():

	if alpha_down:
#		Square.modulate.a -= 0.15
		Square.modulate.a -= 0.1
	else:
#		Square.modulate.a += 0.1
		Square.modulate.a += 0.1
		
	if Square.modulate.a <= 0:
		alpha_down = false
	elif Square.modulate.a >= 1:
		alpha_down = true

func _on_Blink_Timer_timeout():
	blink()
#	for Square in Squares:
#		blink(Square)
		
#		var thread = Thread.new()
#		thread.start(self, "blink", Square)

#func assign_position(x, y):
#	position = Vector2(x, y)
