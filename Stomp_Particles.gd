extends CPUParticles2D

#onready var player = get_node("Level/Background2/Player")
func _ready():
#	visible = false
	initial_velocity = 900
	radial_accel = 0

func _on_Timer_timeout():
	queue_free()

#func _physics_process(delta):
#	position = player.position
func _on_Timer2_timeout():
#	visible = true
	initial_velocity = 0
	radial_accel = -3000
#	pass
