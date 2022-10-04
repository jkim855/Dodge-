extends Node2D

onready var Level = get_parent().get_parent()

func _ready():
#	appear()
	
		
#	set_physics_process(false)
	pass


func _physics_process(_delta):
	position.x -= Global.wall_speed
	if get_global_position().x < -150:
		execute()
		
func execute():
	set_physics_process(false)
#	print(Global.wall_count)
	if Global.wall_count == 1:

		Level.start_wall_timer()
		queue_free()
	else:
		Global.wall_count -= 1
		Level.create_consecutive_wall()
		
#			print("hi")

#func start_timer():
#	$Timer.start()

#func _on_Timer_timeout():
#	set_physics_process(true)


func _on_Down_body_entered(_body):
	Level.calc()

func _on_Up_body_entered(_body):
	Level.calc()
