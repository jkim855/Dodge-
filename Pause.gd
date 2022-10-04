extends Node2D

func _on_Play_pressed():
	get_tree().change_scene("res://src/Level.tscn")
	get_tree().paused = false
