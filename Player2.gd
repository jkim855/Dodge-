extends Actor

onready var jump_count = 0
onready var float_count = 0
onready var invincible = false
onready var super_invincible = false
onready var iTexture = load("res://assets/iplayer.png")
onready var oTexture = load("res://assets/skins/player.png")
onready var is_floating = false
onready var dash_count = 0
onready var dash = get_node("Dash")
onready var dash_speed = Vector2(1300, 1000)
onready var speed
onready var dash_timer = get_node("Dash_Timer")
onready var sprite = $PlayerSprite
onready var float_particles = load("res://src/Float_Particles.tscn")
onready var super_jump_able = false
onready var jump_able = true
onready var Super_Jump_Timer = get_node("Super_Jump_Timer")
onready var dash_direction: = Vector2(0,0)
onready var direction = Vector2(0,0)
onready var was_on_floor = false
onready var left = 0.0
onready var right = 0.0
onready var inv_off = load("res://assets/invincible.png")
onready var inv_on = load("res://assets/invincible_on.png")


func _ready():
	$PlayerSprite.set_texture(Global.skins[Global.data["skins"]["selected"]])
#	$PlayerSprite.modulate = Global.skin
#	if Global.skin_index == Global.skins.size()-1:
#		$PlayerSprite.modulate = Color(1,1,1)
	
func set_sprite():
	if invincible:
		$PlayerSprite.set_texture(iTexture)

	else:
		$PlayerSprite.set_texture(oTexture)

func _physics_process(_delta):

#	if Transition.value:
#		self.visible = false
	#Invincibility (for testing)
	if Input.is_action_just_pressed("invincible"):
		super_invincible = !super_invincible
		if super_invincible:
			
			#$PlayerSprite.set_texture(iTexture)
#			get_node("../WorldEnvironment").enabled = false
			
			get_parent().get_parent().get_node("Touch_Buttons/Invincible").normal = inv_on
		else:
			get_parent().get_parent().get_node("Touch_Buttons/Invincible").normal = inv_off
			
	direction = get_direction(direction)
	
	dash_direction.x = direction.x
	#print(velocity.y, " dash: ", dash.is_dashing(), dash_direction.y, Input.is_action_pressed("move_up"))
	dash_speed = Vector2(1300, 800)
	speed = move_speed
	if not is_floating:
		gravity = 3000.0
	
	if Input.is_action_pressed("move_up") or Global.move_vector.y < -37:
		if !dash.is_dashing():
			dash_direction.y = -1.0
	
		if (Input.is_action_pressed("jump") and super_jump_able 
		and !Input.is_action_pressed("move_left") 
		and !Input.is_action_pressed("move_right") 
		and Global.move_vector.x > -15 
		and Global.move_vector.x < 15
		and (Global.move_vector.y < -50 or Input.is_action_pressed("move_up"))):
			
			Super_Jump_Timer.connect("timeout", self, "unlock_jump")
			Super_Jump_Timer.start()
			jump_able = false
			velocity.y = -1200


	elif (Input.is_action_pressed("move_down") 
	or Global.move_vector.y > 37):
		
		if !dash.is_dashing():
			dash_direction.y = 1.0

		if (Input.is_action_pressed("jump") 
		and !is_on_floor() 
		and Global.move_vector.x > -15 
		and Global.move_vector.x < 15
		and (Global.move_vector.y > 50 or Input.is_action_pressed("move_down"))):
			
			velocity.y = gravity * get_physics_process_delta_time() * 60
			
	elif !dash.is_dashing():
		dash_direction.y = 0.0
		
	if Input.is_action_just_pressed("dash") and dash_count < 1 and dash_direction != Vector2.ZERO and !is_floating:
		was_on_floor = is_on_floor()
		dash.start_dash(sprite, 0.2)
		dash_count += 1
		#print("Start: ", dash_direction)
		dash_timer.connect("timeout", self, "end_dash")
#		dash_timer.connect("timeout", self, "end_dash", [dash_direction])
		dash_timer.start()
#@
	if dash.is_dashing():
#		print(dash_direction)
		speed = dash_speed
		gravity = 0.0
		if is_on_floor() and !was_on_floor:
			direction.x = 0.0
			
		if dash_direction.y == -1.0:
			velocity.y = -1200
		elif dash_direction.y == 1.0:
			velocity.y = 1500
		else:
			velocity.y = 0.0

#		ATTEMPT at 대쉬 방향 세밀화 (not just 8 direction)
#		if dash_direction.y == 0:
#			velocity.y = 0
#		else:
#			velocity.y = dash_speed.y * dash_direction.y

#CHANGE: add back the "and float_count < 1" condition below
	if Input.is_action_pressed("float") and float_count < 1 and not is_on_floor() and jump_able:
		velocity = Vector2.ZERO
		gravity = 0.0 
		float_count += 1
		is_floating = true
		var float_particle_instance = float_particles.instance()
		get_tree().current_scene.add_child(float_particle_instance)	
		float_particle_instance.global_position = Vector2(global_position.x-6.5, global_position.y+60)
	
	else:
		if Input.is_action_just_released("float"):
			gravity = 3000.0
			is_floating = false
		
	velocity = calculate_velocity(velocity, speed, direction)

	velocity = move_and_slide(velocity, FLOOR_NORMAL)	
	
	#print(Super_Jump_Timer.time_left, " position: ", global_position.y)
	if is_on_floor():
		jump_count = 0
		float_count = 0
		dash_count = 0
		super_jump_able = true
	
	else:
		super_jump_able = false

func unlock_jump():
	jump_able = true
	Super_Jump_Timer.stop()
	gravity = 3000
	velocity.y = -500

func get_direction(direction) -> Vector2:
	var xVel
	var yVel = 0.0
	
	var x = 0
	
	if is_floating:
		xVel = 0.0
		
	else:
		if !dash.is_dashing():
			if (Input.is_action_pressed("move_right") or 
			Global.move_vector.x > x):
#			(-0.7 < Global.move_vector.y and Global.move_vector.y < 0.7)):
				right = 1 
			else:
				right = 0
			if (Input.is_action_pressed("move_left") or 
			Global.move_vector.x < -x):
				left = 1
			else:
				left = 0
#			xVel = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
			xVel = right - left
			
		else:
			xVel = direction.x
	
	if (Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("small_jump")) and jump_count < 2:
		jump_count += 1
		yVel = -1.0

		
	return Vector2(
		xVel, yVel
	)
	
func end_dash():
##	print("End: ", dash_direction)
##	print("---------------")

	if dash_direction.y == -1.0:
		velocity.y = -500

func calculate_velocity(
		linear_velocity: Vector2,
		speed: Vector2,
		direction: Vector2
	) -> Vector2:
	var new_velocity = linear_velocity
	
	new_velocity.x = speed.x * direction.x
	if Super_Jump_Timer.is_stopped():
		new_velocity.y += gravity * get_physics_process_delta_time()


	if direction.y != 0.0 and jump_able:
#		new_velocity.y = speed.y * 1.2 * direction.y
		if jump_count == 2 or Input.is_action_just_pressed("small_jump"):
			#changed jump values
			#0.9 -> 1.1, 1.2
			new_velocity.y = speed.y *  1.1 * direction.y

		elif jump_count == 1:
			new_velocity.y = speed.y * 1.15 * direction.y

	if Input.is_action_just_released("jump") and new_velocity.y < -500 and Super_Jump_Timer.is_stopped():
		new_velocity.y = -500
#		pass
#	print(new_velocity.y)

	return new_velocity

func restore_effect():
#	$restore_particles.emitting = true
	$Restore.visible = true
	$Restore_in.start()

func _on_Restore_Timer_timeout():
	if $Restore.modulate.a > 0:
		$Restore.modulate.a -= 0.2
	else:
		$Restore.visible = false
#		$restore_particles.emitting = false
		$Restore_Timer.stop()


func _on_Restore_in_timeout():
	if $Restore.modulate.a < 1:
		$Restore.modulate.a += 0.2
	else:
#		$Restore.emitting = false
		$Restore_Timer.start()
		$Restore_in.stop()


func _on_Fade_In_animation_finished(anim_name):
	z_index = 0

func move_up(pos):
	
#	position.y = 410
	position = pos

#func reset_velocity():
#	velocity = Vector2.ZERO
#	velocity = move_and_slide(velocity, FLOOR_NORMAL)	
