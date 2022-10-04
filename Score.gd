extends Label

onready var time = 0.0
var off = false

func _physics_process(delta):
		
	self.text = str(floor(time))
	time += delta
	Global.set_score(stepify(time, 0.01))
	$decimal.text = str(stepify(time-floor(time), 0.01)).substr(1)
	
func pause():
	set_physics_process(false)
	
func resume():
	set_physics_process(true)

func flash():
	var down = true
	modulate = Color(1.2, 1.2, 0.45)
	while true:
		if off:
			modulate = Color(1, 1, 1)
			modulate.a = 1
			break
		if down:
			modulate.a -= 0.01
		else:
			modulate.a += 0.01
		if modulate.a >= 1.5:
			down = true
		elif modulate.a <= 1:
			down = false
		yield(get_tree().create_timer(0.1), "timeout")
