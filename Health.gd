extends Node2D

onready var player = get_node("../../Background2/Player")
onready var inv_timer = $Timer
onready var guard_inv_timer = $Timer2
onready var alpha_down = true
onready var glow = get_node("../../WorldEnvironment")
onready var Level = get_parent().get_parent()
onready var sprite = get_node("../../Background2/Player/PlayerSprite")

func _ready():
	set_process(false)

func _process(_delta):
	blink()
	
func blink():
	#0.08 / 0.05
	if alpha_down:
		sprite.modulate.a -= 0.05
	else:
		sprite.modulate.a += 0.05
		
	if sprite.modulate.a <= 0:
		alpha_down = false
	elif sprite.modulate.a >= 0.8:
		alpha_down = true
#	if alpha_down:
#		player.modulate.a -= 0.08
#	else:
#		player.modulate.a += 0.05
#
#	if player.modulate.a <= 0:
#		alpha_down = false
#	elif player.modulate.a >= 1:
#		alpha_down = true
		
func set_life():
	$Hit.play()
	if Level.lives == 4:
		$Life4.visible = false
	if Level.lives == 3:
		$Life3.visible = false
	if Level.lives == 2:
		$Life2.visible = false
	if Level.lives == 1:
		$Life1.visible = false
	set_inv_on()

func set_lives():
	if Level.lives >= 1:
		$Life1.visible = true
	if Level.lives >= 2:
		$Life2.visible = true
	if Level.lives >= 3:
		$Life3.visible = true
	if Level.lives >= 4:
		$Life4.visible = true

func set_life_up():
	$Heal.play()
	if Level.lives == 3:
		$Life4.visible = true
	if Level.lives == 2:
		$Life3.visible = true
	if Level.lives == 1:
		$Life2.visible = true
	set_process(false)
	player.modulate.a = 1
	player.invincible = true
#	recover_timer.start()
	inv_timer.start()

func set_inv_on():
#	glow.enabled = false
	set_process(true)
	player.invincible = true
	inv_timer.start()

func set_inv_on_resume():
#	glow.enabled = false
	set_process(true)
	player.invincible = true
	$inv_timer2.start()

func guard_inv():
	player.invincible = true
	guard_inv_timer.start()

#func set_inv_off():
##	glow.enabled = true
#	sprite.modulate.a = 1
#	set_process(false)
#	player.invincible = false


func _on_Timer2_timeout():
	player.invincible = false


func _on_Timer_timeout():
	sprite.modulate.a = 1
	set_process(false)
	player.invincible = false


func _on_inv_timer2_timeout():
	sprite.modulate.a = 1
	set_process(false)
	player.invincible = false
