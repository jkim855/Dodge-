extends Sprite

func _ready():
#	if Global.skin_index == 1:
#		modulate.h = 359
	$GhostTween.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.5, 3, 1)
	$GhostTween.start()

func _on_GhostTween_tween_completed(_object, _key):
	queue_free()
