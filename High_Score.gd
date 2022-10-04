extends Label


func _ready():
	var high_score = Global.data["high_score"]
	var label = str(stepify(high_score, 0.01))
	if len(label) == 1:
		label += ".00"
	self.text = label

func fade_in():
	while modulate.a < 1:
		modulate.a += 0.05
		get_node("../High_Score_Label").modulate.a += 0.05
		yield(get_tree().create_timer(0.07), "timeout")
	yield(get_tree().create_timer(0.6), "timeout")
	get_node("../../").fade_money()
