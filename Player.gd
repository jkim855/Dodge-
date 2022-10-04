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
var is_shrinked = false
var shrink_factor = 1
var guarding = false
onready var ghost_timer = get_node("Dash/Ghost_Timer")
onready var jump_particles = load("res://src/Jump_Particles.tscn")
onready var stomp_particles = load("res://src/Stomp_Particles.tscn")
onready var flash_particles = load("res://src/Flash_Particles.tscn")

var max_jump = 2
var max_dash = 1
var is_stomping = false
var hooking = false
var hook_direction
var accel_count = 1
var tp_dist = 220
var flashing = false
var max_abil = false
var max_accel = 1500
var accel_increment = 100
var level
var on_wall = false
var abil_test = false
var max_rotation
var ability
var stored_direction
var dest
var attack_direction
var attack_count = 0
#onready var joystick = get_node("../../Touch_Buttons/Joypad/Joystick")
var attack_increment = 40
var max_blink
var blink_count = 0
var shrink_size

func _ready():

	print(Global.item)
	if Global.item == "jump+1":
		max_jump = 3
		
	if Global.item == "dash+1":
		max_dash = 2
		
	if Global.ability:
		level = Global.data["levels"][Global.ability]
		set_ability_variables()
		
	$PlayerSprite.set_texture(Global.skins[Global.data["skins"]["selected"]])
#	$PlayerSprite.modulate = Global.skin
#	if Global.skin_index == Global.skins.size()-1:
#		$PlayerSprite.modulate = Color(1,1,1)

func set_ability_variables():
#	Global.move_vector = Vector2.ZERO
	ability = Global.ability
	if ability == "float":
		if level == 1:
			$Float_Timer.wait_time = 0.5
			max_abil = false
		elif level == 2:
			$Float_Timer.wait_time = 0.8
			max_abil = false
		else:
			max_abil = true
	
	elif ability == "blink":
		if level == 1:
			max_blink = 1
		elif level == 2:
			max_blink = 2
	
	elif ability == "shrink":
		if level == 1:
			shrink_size = Vector2(0.6, 0.6)
		elif level == 2:
			shrink_size = Vector2(0.5, 0.5)
		else:
			shrink_size = Vector2(0.4, 0.4)
	
	elif ability == "hook":
		if level == 1:
			max_accel = 1500
			accel_increment = 100
		elif level == 2:
			max_accel = 1700
			accel_increment = 102
		else:#h
			max_accel = 2000
			accel_increment = 105
	

func set_sprite():
	if invincible:
		$PlayerSprite.set_texture(iTexture)

	else:
		$PlayerSprite.set_texture(oTexture)

func _physics_process(_delta):
#	store_direction()
	#test
#	if Input.is_action_just_pressed("1"):
#		level = 1
#		abil_test = true
#		set_ability_variables()
#		use_ability()
#	elif Input.is_action_just_pressed("2"):
#		level = 2
#		abil_test = true
#		set_ability_variables()
#		use_ability()
#	elif Input.is_action_just_pressed("3"):	
#		level = 3
#		abil_test = true
#		set_ability_variables()
#		use_ability()
	#Invincibility (for testing)
	if Input.is_action_just_pressed("invincible") and Global.data["admin"]:
		super_invincible = !super_invincible
#		if super_invincible:
#
#			#$PlayerSprite.set_texture(iTexture)
##			get_node("../WorldEnvironment").enabled = false
#			pass
##			get_parent().get_parent().get_node("Touch_Buttons/Invincible").normal = inv_on
#		else:
##			get_parent().get_parent().get_node("Touch_Buttons/Invincible").normal = inv_off
#			pass
#
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
#		and !Input.is_action_pressed("move_left") 
#		and !Input.is_action_pressed("move_right") 
#		and Global.move_vector.x > -15 
#		and Global.move_vector.x < 15
		and (Global.move_vector.y < -50 or Input.is_action_pressed("move_up"))):
			
#			Super_Jump_Timer.connect("timeout", self, "unlock_jump")
			Super_Jump_Timer.start()
			jump_able = false
			velocity.y = -1200 * shrink_factor
			
#			Engine.time_scale = 0.1
			var jump_particle_instance = jump_particles.instance()
			get_tree().current_scene.add_child(jump_particle_instance)	
			jump_particle_instance.global_position = Vector2(global_position.x, global_position.y)
			
			$Super_Jump.play()

	elif (Input.is_action_pressed("move_down") 
	or Global.move_vector.y > 37):
		
		if !dash.is_dashing():
			dash_direction.y = 1.0

		if (Input.is_action_pressed("jump") 
		and !is_on_floor()): 
#		and Global.move_vector.x > -15 
#		and Global.move_vector.x < 15
#		and (Global.move_vector.y > 50 or Input.is_action_pressed("move_down"))):
			
			velocity.y = gravity * get_physics_process_delta_time() * 60
			
			
			
			if !is_stomping:
				is_stomping = true
				$Stomp.play()
#				var stomp_particle_instance = stomp_particles.instance()
#				add_child(stomp_particle_instance)	
#				stomp_particle_instance.global_position = Vector2(global_position.x, global_position.y+10)
			
	elif !dash.is_dashing():
		dash_direction.y = 0.0
		
	if Input.is_action_just_pressed("dash") and dash_count < max_dash and dash_direction != Vector2.ZERO and !is_floating:
		was_on_floor = is_on_floor()
		dash.start_dash(0.2)
		
		dash_count += 1
		#print("Start: ", dash_direction)
#		dash_timer.connect("timeout", self, "end_dash")
#		dash_timer.connect("timeout", self, "end_dash", [dash_direction])
		
		dash_timer.start()
#dash
	if dash.is_dashing():
#		print(dash_direction)
		speed = dash_speed * shrink_factor
#		speed.x = 1000
		gravity = 0.0
		if is_on_floor() and !was_on_floor:
			direction.x = 0.0
			
		if dash_direction.y == -1.0:
#			velocity.y = -1200
			velocity.y = -1200 * shrink_factor
		elif dash_direction.y == 1.0:
#			velocity.y = 1500
			velocity.y = 1200 * shrink_factor
		else:
			velocity.y = 0.0

#		ATTEMPT at 대쉬 방향 세밀화 (not just 8 direction)
#		if dash_direction.y == 0:
#			velocity.y = 0
#		else:
#			velocity.y = dash_speed.y * dash_direction.y

	if Input.is_action_just_pressed("float"):
		use_ability()
		
	if Global.ability == "float":
		if Input.is_action_just_released("float") or Input.is_action_just_released("1") or Input.is_action_just_released("2") or Input.is_action_just_released("3"):	
			gravity = 3000.0
			is_floating = false

	if ability != "hook" or !hooking:	
		velocity = calculate_velocity(velocity, speed, direction)

	velocity = move_and_slide(velocity, FLOOR_NORMAL)	
	
	#print(Super_Jump_Timer.time_left, " position: ", global_position.y)
	if is_on_floor():
		jump_count = 0
		float_count = 0
		dash_count = 0
		super_jump_able = true
		is_stomping = false
		blink_count = 0
	
	else:
		super_jump_able = false

#func _input(event):
#	if Input.is_action_just_pressed("float"):
#		use_ability()
#		print("pressed")
func attack():
	velocity.y = 0
#	joystick.pause()
	accel_count = 1
	if stored_direction == -1:
		attack_direction = -1
		dest = global_position.x - 200
		if dest < 180:
			dest = 180
	else:
		attack_direction = 1
		dest = global_position.x + 200
		if dest > 944:
			dest = 944
	$attack.start()
	$attack_dur.start()

func use_ability():
#	print("use")
	if ability == null:
		attack()
	if ability == "float":
		if float_count < 1 and not is_on_floor() and jump_able:
			velocity = Vector2.ZERO
			
			if !max_abil:
				$Float_Timer.start()
		
			gravity = 0.0 
			float_count += 1
			is_floating = true
			var float_particle_instance = float_particles.instance()
#			get_tree().current_scene.add_child(float_particle_instance)	
			get_node("../../").add_child(float_particle_instance)	
			float_particle_instance.global_position = Vector2(global_position.x-6.5, global_position.y+60)
			
			#test
			if abil_test:
				if level == 1:
					
					float_particle_instance.initial_velocity = 600
					float_particle_instance.orbit_velocity = 2
					float_particle_instance.get_child(0).wait_time = 0.5
					float_particle_instance.get_child(0).start()
				elif level == 2:
					float_particle_instance.initial_velocity = 380
					float_particle_instance.orbit_velocity = 1.25
					float_particle_instance.get_child(0).wait_time = 0.8
					float_particle_instance.get_child(0).start()
				else:
					pass
		
	elif ability == "shrink":
#		if Input.is_action_just_pressed("float"):
		if !is_shrinked:
			scale_down()
		else:
			scale_up()
		
	elif ability == "guard":
#		if Input.is_action_just_pressed("float"):
		if !guarding:
			
			create_guard()
	#a
	elif ability == "hook":
#		if Input.is_action_just_pressed("float") and dash_direction.x != 0:
		if !on_wall and dash_direction.x != 0:
#			print("use")
#			$Hook.play()
			if !hooking:
				var head_start
				if level == 3:
					head_start = 500
					jump_count = 1
					dash_count = 0
				elif level == 2:
					head_start = 300
				else:
					head_start = 0
				if dash_direction.x > 0:
					hook_direction = 1
					velocity.x += head_start
#					velocity.x += 200
#					velocity.x += 1000
				else:
					hook_direction = 0
					velocity.x -= head_start
#					velocity.x -= 200
#					velocity.x -= 1000
				$hook_accel.start()
				#3
				
				velocity.y = 0
				hooking = true
				var hook = load("res://src/Hook.tscn").instance()
#				get_tree().current_scene.add_child(hook)
				get_node("../../").add_child(hook)
		
	elif ability == "blink" and (level == 3 or blink_count < max_blink):

		if dash_direction != Vector2.ZERO:
			blink_count += 1
			if !flashing:
				flashing = true
				if level == 3:
					jump_count = 1
					dash_count = 0
				$flash.start()
						
			if dash_direction.x > 0:
				if global_position.x + tp_dist > 980:
					global_position.x = 980
				else:
					global_position.x += tp_dist
#					
			elif dash_direction.x < 0:
				if global_position.x - tp_dist < 140:
					global_position.x = 140
				else:
					global_position.x -= tp_dist
						
			if dash_direction.y > 0:
				if global_position.y + tp_dist > 538:
					global_position.y = 538
				else:
					global_position.y += tp_dist + 75
#					
			elif dash_direction.y < 0:
				if global_position.y - tp_dist < -250:
					global_position.y = -250
				else:
					global_position.y -= tp_dist + 75
			
			velocity.y = 0
			var flash_particle_instance = flash_particles.instance()
#			
			add_child(flash_particle_instance)	
			flash_particle_instance.global_position = Vector2(global_position.x, global_position.y)
	
	elif ability == "dodge":
		if $rotation.is_stopped():
#			if direction.x == -1:
			if stored_direction == -1:	
				max_rotation = -90
			else:
				max_rotation = 90
			
			$rotation.start()
		
func destroy_guard():
	$Guard/Timer.start()
	
	guarding = false

func create_guard():
	$Guard.visible = true
	guarding = true

func scale_down():
	$Grow_Timer.stop()
	$Shrink_Timer.start()
	is_shrinked = true
	shrink_factor = 0.7
	
func scale_up():
	$Shrink_Timer.stop()
	$Grow_Timer.start()
	is_shrinked = false
	shrink_factor = 1
	
func resume_move():
	velocity = calculate_velocity(velocity, speed, direction)

	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	
func unlock_jump():
	jump_able = true
	Super_Jump_Timer.stop()
	gravity = 3000
	velocity.y = -500

func get_direction(direction) -> Vector2:
	var xVel
	var yVel = 0.0
	
	var x = 0
	
	if is_floating or !$attack_dur.is_stopped():
		xVel = 0.0
		
	else:
		if !dash.is_dashing():
			if (Input.is_action_pressed("move_right") or 
			Global.move_vector.x > x):
#			(-0.7 < Global.move_vector.y and Global.move_vector.y < 0.7)):
				right = 1 
				stored_direction = 1
			else:
				right = 0
			if (Input.is_action_pressed("move_left") or 
			Global.move_vector.x < -x):
				left = 1
				stored_direction = -1
			else:
				left = 0
#			xVel = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
			xVel = right - left
			
		else:
			xVel = direction.x
	
	if Input.is_action_just_pressed("jump") and jump_count < max_jump:
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
	
	if dash_direction.y == 1.0:
		velocity.y = 100

func calculate_velocity(
		linear_velocity: Vector2,
		speed: Vector2,
		direction: Vector2
	) -> Vector2:
	var new_velocity = linear_velocity
	
	new_velocity.x = speed.x * direction.x
	
#	if flashing:
#		new_velocity.y += 1/2 * gravity * get_physics_process_delta_time() * shrink_factor
#
	if $attack_dur.is_stopped() and !flashing and Super_Jump_Timer.is_stopped():
		new_velocity.y += gravity * get_physics_process_delta_time() * shrink_factor
		

	if direction.y != 0.0 and jump_able:
#		new_velocity.y = speed.y * 1.2 * direction.y
		
		if 1 < jump_count:
			
			#changed jump values
			#0.9 -> 1.1, 1.2
			new_velocity.y = speed.y *  1.15 * direction.y * shrink_factor

		elif jump_count == 1:
			new_velocity.y = speed.y * 1.15 * direction.y * shrink_factor

	if Input.is_action_just_released("jump") and new_velocity.y < -500 and Super_Jump_Timer.is_stopped():
		new_velocity.y = -500 * shrink_factor
#		pass
#	print(new_velocity.y)

	return new_velocity

func restore_effect():
#	$restore_particles.emitting = true
	$PlayerSprite.modulate.a = 1
	get_node("../../Touch_Buttons/Health").set_process(false)
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


func _on_Fade_In_animation_finished(_anim_name):
	z_index = 0

func move_up(pos):
	
#	position.y = 410
	position = pos

#func reset_velocity():
#	velocity = Vector2.ZERO
#	velocity = move_and_slide(velocity, FLOOR_NORMAL)	



func _on_Dash_Timer_timeout():
	end_dash()


func _on_Shrink_Timer_timeout():
	if scale - Vector2(0.05, 0.05) >= shrink_size:
		dash.instance_shrink_ghost()
		scale -= Vector2(0.05, 0.05)
		
	else:
		scale = shrink_size
		$Shrink_Timer.stop()
		ghost_timer.stop()

func _on_Grow_Timer_timeout():
	if scale + Vector2(0.05, 0.05) <= Vector2(0.77, 0.77):
		dash.instance_grow_ghost()
		scale += Vector2(0.05, 0.05)
		
	else:
		scale = Vector2(0.77, 0.77)
		$Grow_Timer.stop()
		ghost_timer.stop()


func _on_Timer_timeout():
	if $Guard.modulate.a > 0:
		$Guard.modulate.a -= 0.1
	else:
		$Guard/Timer.stop()
		$Guard.modulate.a = 1
		$Guard.visible = false


func _on_Float_Timer_timeout():
	gravity = 3000.0
	is_floating = false


func _on_Super_Jump_Timer_timeout():
	unlock_jump()


func _on_hook_left_body_entered(_body):
	on_wall = true
	if hooking:
		end_hook()

func _on_hook_right_body_entered(_body):
	on_wall = true
	if hooking:
		end_hook()

func end_hook():
	hooking = false
	get_node("../../Hook").queue_free()
#	get_node("../../../Hook").queue_free()
	accel_count = 1
	$hook_accel.stop()

func _on_hook_accel_timeout():
	if abs(velocity.x) > max_accel:
		$hook_accel.stop()
		return
	if hook_direction == 0:
		velocity.x -= accel_count * accel_increment
	else:
		velocity.x += accel_count * accel_increment
	accel_count *= 2


func _on_flash_timeout():
	flashing = false
#	invincible = false


func _on_hook_right_body_exited(_body):
	on_wall = false


func _on_hook_left_body_exited(_body):
	on_wall = false


func _on_rotation_timeout():
	
	if max_rotation < 0:
		if rotation_degrees > max_rotation:
			rotation_degrees -= 15
		else:
			rotation_degrees = 0
			$rotation.stop()
	else:
		if rotation_degrees < max_rotation:
			rotation_degrees += 15
		else:
			rotation_degrees = 0
			$rotation.stop()


func _on_attack_timeout():

#	print(global_position.x)
	
	if attack_direction == -1:
#		if global_position.x > dest:
		if global_position.x - attack_increment * accel_count > dest:
			global_position.x -= attack_increment  * accel_count
		else:
			global_position.x = dest
			
#		else:
#			if attack_count < 1:
#				accel_count = 1
#				dest += 200
#				attack_direction = 1
#				$attack.start()
#				$attack_dur.start()
#				attack_count += 1
#			else:
#				joystick.resume()
#				$attack.stop()
##				gravity = 3000
#				attack_count = 0 
	else:

#		if global_position.x < dest:
		if global_position.x + attack_increment  * accel_count < dest:
			global_position.x += attack_increment  * accel_count
		else:
			global_position.x = dest
#		else:
#			if attack_count < 1:
#				accel_count = 1
#				dest -= 200
#				attack_direction = -1
#				$attack.start()
#				attack_count += 1
#			else:
#				$attack.stop()
#				joystick.resume()
#				gravity = 3000
#				attack_count = 0 
	accel_count *= 1.7


func _on_attack_dur_timeout():
#	$attack.stop()
	if attack_count < 1:
#		yield(get_tree().create_timer(0.1), "timeout")
		accel_count = 1
		if attack_direction == 1:
		
			dest -= 200
			attack_direction = -1
		else:
			dest += 200
			attack_direction = 1
		$attack.start()
		$attack_dur.start()
		attack_count += 1
	else:
		accel_count = 1
		$attack.stop()
#		joystick.resume()
		gravity = 3000
		attack_count = 0 
