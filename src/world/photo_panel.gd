extends Sprite3D


func _ready() -> void:
	get_parent().get_node("TimeManager").connect("game_state_update", self, "_on_game_end")


func _on_game_end(lost: bool) -> void:
	yield(get_tree().create_timer(3), "timeout")
	if lost:
		texture = load("res://assets/other/LoosePanel.png")
	else:
		texture = load("res://assets/other/WinPanel.png")
	$Tween.interpolate_property(self, "modulate:a", 0, 0.95, 5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()
	if not lost:
		yield(get_tree().create_timer(3), "timeout")
		$AudioStreamPlayer.play()
