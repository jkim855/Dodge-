extends CPUParticles2D


#func _ready():
#	initial_velocity = 500


func _on_Timer_timeout():
	queue_free()


#func _on_Timer2_timeout():
#	initial_velocity = 0
##	radial_accel = -1000
#	pass
