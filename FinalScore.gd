extends Label
var num = 0.00
var score
var inc
var label
#func set_text(num):
#	self.text = str(int(num * 10))
func _ready():
	print(Global.score)
	score = stepify(Global.score, 0.01)
#	score = 170.21
#	inc = stepify(max(0.01 * score, 0.02), 0.01)
	inc = 1.3
#	score = 325.64
	#0.9, 0
	label = str(score)
#	print(score)
	var decimal = str(score - floor(score))
	
	if len(decimal) == 1:
		label += ".00"
	elif len(decimal) == 3:
		label += "0"
	
func _physics_process(_delta):
	if num >= score:
		self.text = label
		yield(get_tree().create_timer(0.6), "timeout")
		get_node("../High_Score").fade_in()
		set_physics_process(false)
		
	else:
		num += inc
		self.text = str(num)
	
