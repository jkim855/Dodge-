extends Node2D


func _ready():
	
	
	
	create_warning()

func create_warning():
	var pos = generate_random(1,3)
		
	if pos == 1:
		$Laser/Up/CollisionShape2D.disabled = true
#		$Laser.position.y -= 162
		$Laser.position.y -= 150
		$Warning/Top.visible = false
		
	elif pos == 3:
		$Laser/Down/CollisionShape2D2.disabled = true
#		$Laser.position.y += 162
		$Laser.position.y += 150
		$Warning/Bottom.visible = false
	else:
		$Warning/Middle.visible = false
	
func generate_random(n1, n2):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return rng.randi_range(n1, n2)

