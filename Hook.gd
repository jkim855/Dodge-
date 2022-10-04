extends Node2D

#onready var player = get_node("../Level/Background2/Player")
onready var player = get_node("../Background2/Player")

func _ready():
	var player_pos = player.global_position
	self.points[0] = player_pos
	if player.hook_direction == 0:
		self.points[1] = Vector2(146, player_pos.y)
	else:
		self.points[1] = Vector2(980, player_pos.y)
		$end.rotation_degrees = 180
	$end.global_position = self.points[1]
	if player.hook_direction == 0:
		$end.global_position.x += 10
	else:
		$end.global_position.x -= 10
	
func _physics_process(_delta):
	self.points[0] = player.global_position
	self.points[0].x = self.points[0].x - 10
