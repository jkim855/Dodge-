extends Node2D

onready var inner = $Inner
onready var outer = $Outer
onready var foTimer = $foTimer
onready var fiTimer = $fiTimer
onready var breatheTimer = $breatheTimer
onready var breatheTimer2 = $breatheTimer2
var inc = true
var inc2 = true
onready var fovTimer = $fovTimer
onready var horizontal = $Horizontal
onready var fivTimer = $fivTimer

var alpha_down = true
var rotated
var rotating
onready var player = get_node("../Background2/Player")
onready var Tiles = get_node("../Background2/Tiles")


func _process(_delta):
	if Global.square_pattern:
#		set_breathe(false)
		outer.modulate.a = 1.0
#	else:
#		if breatheTimer.is_stopped():
#			set_breathe(true)

func set_breathe(toggle):
	if toggle:
		breatheTimer.start()
		breatheTimer2.start()
	else:
		breatheTimer.stop()
		breatheTimer2.stop()

func _ready():
	set_breathe(true)
	outer.modulate.a = 0.7
	inner.modulate.a = 0.5
#	if Global.laser_pattern:
		
		
#		breatheTimer.start()
#		breatheTimer2.start()

func fade_out():
	#1/1
	inner.modulate.a += 0.3
	foTimer.start()
	outer.modulate.a += 0.3
	$OuterGlow.start()

func fade_in():
	fiTimer.start()

func fade_out_vertical():
	horizontal.visible = true
	fovTimer.start()
	foTimer.start()
	set_breathe(false)

func fade_in_vertical():
	fiTimer.start()
	fivTimer.start()
	

func _on_foTimer_timeout():
	
	if inner.modulate.a > 0:
		inner.modulate.a -= 0.1
	else:
		foTimer.stop()
		
	
		
func _on_fiTimer_timeout():
	#1
	if inner.modulate.a < 0.7:
		inner.modulate.a += 0.05
	else:
		set_breathe(true)
		fiTimer.stop()
		#1
		outer.modulate.a += 0.2
		$OuterGlow.start()


func _on_breatheTimer_timeout():
#	print(inc)
	#0.025
	if inc:
		inner.modulate.a += 0.0125

	else:
		inner.modulate.a -= 0.0125



	#1.2 / 0.8
	#1.1 / 0.5
	if inner.modulate.a >= 0.7:
		inc = false
	if inner.modulate.a <= 0.6:
		inc = true




func _on_breatheTimer2_timeout():
	if inc2:
		outer.modulate.a += 0.025
	else:
		outer.modulate.a -= 0.025
	
	#1.3/0.7
	if outer.modulate.a >= 0.8:

		inc2 = false
	if outer.modulate.a <= 0.6:
		inc2 = true



func _on_fovTimer_timeout():
	if outer.modulate.a > 0:
		outer.modulate.a -= 0.1
	else:
		fovTimer.stop()

func _on_fivTimer_timeout():
	if outer.modulate.a < 1:
		outer.modulate.a += 0.1
	else:
		fivTimer.stop()
		set_breathe(true)
		horizontal.visible = false


func _on_OuterGlow_timeout():
	if outer.modulate.a > 1:
		outer.modulate.a -= 0.05
	else:
		$OuterGlow.stop()



