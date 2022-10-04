extends CanvasLayer

#func _ready():
#	$InnerCircle.position = $Joystick.position + Vector2(80, 72)

var radius = Vector2(80, 72)

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if $Joystick.is_pressed() and event.position.x < 300 and event.position.y > 300:
			Global.move_vector = calculate_move_vector(event.position)
#			print(Global.move_vector)
			
			$InnerCircle.position = event.position
			$InnerCircle.visible = true
#			print(event.position)

			if ($InnerCircle.position+radius).length() > 150:
				$InnerCircle.set_position($InnerCircle.position.normalized() * 150 - radius)

	if event is InputEventScreenTouch:
		if event.pressed == false:
			$InnerCircle.visible = false
			Global.move_vector = Vector2.ZERO
			
func calculate_move_vector(event_position):
	var texture_center = $Joystick.position + radius
	return (event_position - texture_center)
#	return (event_position - texture_center).normalized()
		



