extends Node2D

onready var durTimer = $Square_Timers/Blink_Duration
onready var cdTimer = $Square_Timers/Cooldown
onready var hitDurTimer = $Square_Timers/Hit_Duration
onready var blink_timer = $Square_Timers/Blink_Timer
onready var alpha_down = true
onready var Level = get_parent()
onready var warning = false
onready var is_running = false

onready var Squares = []
var pattern_no = 1

func _physics_process(delta):

	for Square in Squares:
		if Square.get_overlapping_bodies():
			if Square.get_overlapping_bodies()[0].name == "Player":
				Level.calc()

func _process(delta):
	if !is_running:
		start_pattern()

func generate_random(n1, n2):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return rng.randi_range(n1, n2)

func hitSquare():
	blink_timer.stop()
	set_physics_process(true)
	get_node("../Square").play()
#	var s = []
#	for square in Squares:
#		s.append(square.name.substr(6))
#	print(s)
	
	for Square in Squares:
		Square.modulate = Color(1, 0, 0)
		Square.modulate.a += 0.3
		
	hitDurTimer.connect("timeout", self, "Reset")
	hitDurTimer.start()	

func Reset():
#	print(Squares)
	for Square in Squares:
		Square.modulate = Color(1, 1, 1)
		Square.modulate.a = 0
	Squares = []
	start_pattern()
	set_physics_process(false)
	
#	print(Squares)

func _ready():
	visible = true
	for i in get_children():
		i.modulate.a = 0
#	print(Global.square_pattern)
	set_physics_process(false)

	start_pattern()

func fill_squares_list(sq_no_original):
	var sq_no = sq_no_original

	for i in range(3):

		var direction = []
		if sq_no % 6 != 1 and !Squares.has(get_child(sq_no-1)):
			direction.append("W")
#			print(sq_no, "-", get_child(sq_no-1))
		if sq_no % 6 != 0 and !Squares.has(get_child(sq_no+1)):
			direction.append("E")
#			print(sq_no, "-", get_child(sq_no+1))
		if sq_no > 6 and !Squares.has(get_child(sq_no-6)):
			direction.append("N")
#			print(sq_no, "-", get_child(sq_no-6))
		if sq_no < 13 and !Squares.has(get_child(sq_no+6)):
			direction.append("S")
#			print(sq_no, "-", get_child(sq_no+6))
#		print(sq_no, direction)
		if len(direction) > 0:
			var dir = direction[generate_random(0, len(direction)-1)]
			if dir == "W":
				sq_no -= 1
			elif dir == "E":
				sq_no += 1
			elif dir == "N":
				sq_no -= 6
			else:
				sq_no += 6
		
		Squares.append(get_child(sq_no))


func start_pattern():
	if Global.square_pattern:
		#double
		for i in range(pattern_no):
			var random_sq = get_child(generate_random(1, 18))
			Squares.append(random_sq)
			fill_squares_list(int(random_sq.name.substr(6)))
		
		cdTimer.connect("timeout", self, "start_dur_timer")
		cdTimer.start()
		is_running = true
		
	else:
		is_running = false
		#double
		

func start_dur_timer():

	blink_timer.start()
	durTimer.start()
	durTimer.connect("timeout", self, "hitSquare")	
	
func blink(Square):
	if alpha_down:
		Square.modulate.a -= 0.15
	else:
		Square.modulate.a += 0.1
		
	if Square.modulate.a <= 0:
		alpha_down = false
	elif Square.modulate.a >= 1:
		alpha_down = true

func _on_Blink_Timer_timeout():
	for Square in Squares:
		blink(Square)
#		var thread = Thread.new()
#		thread.start(self, "blink", Square)
