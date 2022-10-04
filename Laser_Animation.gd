extends Node2D

onready var width = get_node("Red").width

func _ready():
	$Red.points[0] = Vector2.ZERO
	$Red.points[1] = Vector2.ZERO

func animate():
#	$Timer.start()
	appear()
	$Red.points[0] = Vector2(0,175)
	$Red.points[1] = Vector2(1150, 600)
	
	
func appear():
	visible = true
	$Tween.stop_all()
	$Tween.interpolate_property($Red, "width", 0, width, 0.2)
	$Tween.start()
	$Timer2.start()

func disappear():
	$Tween.stop_all()
	$Tween.interpolate_property($Red, "width", width, 0, 0.15)
	$Tween.start() 

#func _on_Timer_timeout():
#	appear()
#	$Red.points[0] = Vector2(0,170)
#	$Red.points[1] = Vector2(1150, 540)
	
func _on_Timer2_timeout():
	disappear()
