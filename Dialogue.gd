extends Node2D

onready var window = $window

func _ready():
	MusicController.get_child(0).stop()
	set_process_input(false)
	window.visible = false
	yield(get_tree().create_timer(1.0), "timeout")
	window.visible = true
	window.start()
	set_process_input(true)
	$Arrow.play("Arrow")

#func _input(event):
#	if event is InputEventScreenTouch:
#

