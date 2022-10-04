extends TouchScreenButton

onready var joypad = get_parent()
var boundary = 90
#var boundary = 150
var radius = Vector2(30, 30)

var ongoing_drag = -1
var return_accel = 20
var threshold = 15
var stuck_up = false
var stuck_down = false
onready var lock_up = get_node("../Lock_Up")
#var block = false

func _ready():
	if Global._settings["joystick"]["type"] == 2:
		self.normal = load("res://assets/temp/joystick_inner2.png")

func pause():
#	Global.move_vector = Vector2.ZERO
	set_process_input(false)
#	block = true

func resume():
	set_process_input(true)
#	block = false
	

func _process(delta):
	if ongoing_drag == -1:
		var pos_difference = (Vector2.ZERO - radius) - position
		position += pos_difference * return_accel * delta
		stuck_up = false
		
#	print(ongoing_drag)
	
func _input(event):
#	if InputEventScreenDrag or InputEventScreenTouch:
#	if block:
#		return
	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
#		Global.move_vector = calculate_move_vector(event.position)
#		print(event.position, " - ", pos_from_center)
		var event_dist_from_center = (event.position - joypad.global_position).length()
		var pos_from_center = (event.position - joypad.global_position)
		#if touched within joypad or dragged out from joypad:
		if (event_dist_from_center <= boundary * global_scale.x
			or event.get_index() == ongoing_drag):
#			threshold = 10
			
			if pos_from_center.length() > threshold:
#				print(get_button_pos())
				var vector = get_button_pos()
				if abs(vector.x) > abs(vector.y):
					vector.y = 0
				if abs(vector.y) > abs(vector.x):
					vector.x = 0
				Global.move_vector = vector
				if Global._settings["joystick"]["type"] == 1:
					if vector.x > 0:
						get_node("../../J_right").visible = true
						get_node("../../J_left").visible = false
					elif vector.x < 0:
						get_node("../../J_right").visible = false
						get_node("../../J_left").visible = true
					else:
						get_node("../../J_right").visible = false
						get_node("../../J_left").visible = false
					if vector.y > 0:
						get_node("../../J_down").visible = true
						get_node("../../J_up").visible = false
					elif vector.y < 0:
						get_node("../../J_down").visible = false
						get_node("../../J_up").visible = true
					else:
						get_node("../../J_down").visible = false
						get_node("../../J_up").visible = false
			else:
				Global.move_vector = Vector2.ZERO

			
			set_global_position(event.position - radius * global_scale)
			
			#==========
			if pos_from_center.length() > boundary: 
				set_position(position.normalized() * boundary - radius)
			#==========
			
			#stick up/down (for super jump/stomp), replace with above if you want
#			print(event.position)
#			print(stuck_up)
#			if !stuck_up or stuck_up_pos.length() > 100:
#				set_global_position(event.position - radius * global_scale)
#				stuck_up = false
#			print(get_button_pos().y)
#			if pos_from_center.length() > boundary: 
#				if stuck_up:
#					if pos_from_center.y <= -90 and pos_from_center.x >= -50 and pos_from_center.x <= 50:
#						set_position(Vector2(-radius.x, -radius.y-100))
#						stuck_up = true
##						lock_up.visible = true
##						visible = false
#
#					else:
#						set_position(position.normalized() * boundary - radius)
#						stuck_up = false
##						lock_up.visible = false
##						visible = true
#
#
#				elif stuck_down:
#					if pos_from_center.y >= 60 and pos_from_center.x >= -50 and pos_from_center.x <= 50:
#						set_position(Vector2(-radius.x, -radius.y+100))
#						stuck_down = true
#
#					else:
#						set_position(position.normalized() * boundary - radius)
#						stuck_down = false
#
#				else:
#					if pos_from_center.y < -100 and pos_from_center.x > -15 and pos_from_center.x < 15:
#						set_position(Vector2(-radius.x, -radius.y-100))
#						stuck_up = true
##						lock_up.visible = true
##						visible = false
#
#
#					elif pos_from_center.y > 100 and pos_from_center.x > -15 and pos_from_center.x < 15:
#						set_position(Vector2(-radius.x, -radius.y+100))
#						stuck_down = true
#					else:
#						set_position(position.normalized() * boundary - radius)
##						lock_up.visible = false
##						visible = true
#
#
#			else:
##				lock_up.visible = false
##				visible = true
#				pass
#
#
			ongoing_drag = event.get_index()
	

	if (event is InputEventScreenTouch and !event.is_pressed() 
		and event.get_index() == ongoing_drag):
		Global.move_vector = Vector2.ZERO
		ongoing_drag = -1
		lock_up.visible = false
		get_node("../../J_right").visible = false
		get_node("../../J_left").visible = false
		get_node("../../J_down").visible = false
		get_node("../../J_up").visible = false
#	print(Global.move_vector)
			
func calculate_move_vector(event_position):
	var texture_center = joypad.position + Vector2(boundary, boundary)
	return (event_position - texture_center)
#	return (event_position - texture_center).normalized()
		
func get_button_pos():
	return position + radius

