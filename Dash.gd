extends Node2D

onready var duration_timer = $D_Timer
onready var ghost_timer = $Ghost_Timer
onready var is_dashing = false
var ghost_scene = preload("res://src/DashGhost.tscn")
onready var sprite = get_parent().get_node("PlayerSprite")

func start_dash(duration):
#	self.sprite = sprite
	$dash.play()
	sprite.material.set_shader_param("mix_weight", 0.7)
	sprite.material.set_shader_param("whiten", true)
	
	duration_timer.set_wait_time(duration)
	duration_timer.start()
	ghost_timer.start()
	instance_ghost()

#func shrink(sprite):
#	pass
#	self.sprite = sprite
#	sprite.material.set_shader_param("mix_weight", 0.7)
#	sprite.material.set_shader_param("whiten", true)

func instance_ghost():
	var ghost: Sprite = ghost_scene.instance()
	
	if get_parent().is_shrinked:
		ghost.scale = get_parent().shrink_size
	
	create_ghost(ghost)

func instance_shrink_ghost():
	var ghost: Sprite = ghost_scene.instance()
	ghost.scale = get_parent().scale + Vector2(0.1, 0.1)
	ghost.modulate = Color(0.33, 0.92, 0.33, 1)
	create_ghost(ghost)

func instance_grow_ghost():
	var ghost: Sprite = ghost_scene.instance()
	ghost.scale = get_parent().scale + Vector2(0.1, 0.1)
	ghost.modulate = Color(0.33, 0.92, 0.33, 1)
	create_ghost(ghost)

func create_ghost(ghost):

	get_parent().get_parent().add_child(ghost)

	ghost.global_position = global_position
	ghost.texture = sprite.texture
	ghost.vframes = sprite.vframes
	ghost.hframes = sprite.hframes
	ghost.frame = sprite.frame
	ghost.flip_h = sprite.flip_h

func is_dashing():
	return !duration_timer.is_stopped()

func _on_Ghost_Timer_timeout():
	instance_ghost()

#func end_dash():
#	ghost_timer.stop()
#	sprite.material.set_shader_param("whiten", false)


func _on_D_Timer_timeout():
	ghost_timer.stop()
	sprite.material.set_shader_param("whiten", false)
#
#func delete_dash():
#	if sprite:
#		sprite.material.set_shader_param("purplen", false)
#
#func highlight_purple():
#	if sprite:
#		ghost_timer.stop()
#		print("hi")
#		sprite.material.set_shader_param("whiten", false)
#		sprite.material.set_shader_param("purplen", true)

func delete_dash():
	if sprite:
		ghost_timer.stop()
		sprite.material.set_shader_param("whiten", false)
		duration_timer.stop()
