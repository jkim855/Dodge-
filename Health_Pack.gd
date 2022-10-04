extends Node2D

onready var Level = get_parent()
onready var Health = get_node("../Touch_Buttons/Health")
onready var Player = get_parent().get_node("Background2/Player")
onready var inc = false

func _ready():
#	var x = generate_random(80, 1040)
	var x = generate_random(175, 950)
#	var y = generate_random(100, 580)
	var y = generate_random(125, 500)
	
	position = Vector2(x, y)
	$Timer.start()
	$Warning_Start.start()

func _on_Area2D_body_entered(_body):
	
	if Level.lives < 4:
		Health.set_life_up()
		Level.add_life()
		Player.restore_effect()
		queue_free()

func generate_random(n1, n2):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return rng.randi_range(n1, n2)


func _on_Timer_timeout():
	queue_free()


func _on_Warning_timeout():
	blink()

func blink():
	
	if inc:
		$Sprite.modulate.a += 0.1
	else:
		$Sprite.modulate.a -= 0.1
	
	if $Sprite.modulate.a <= 0:
		inc = true
	if $Sprite.modulate.a >= 0.8:
		inc = false

func _on_Warning_Start_timeout():
	$Warning.start()
