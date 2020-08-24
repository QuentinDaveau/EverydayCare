extends ColorRect

signal closing_done


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_validate_open()
		set_process(false)


func open(first_launch: bool = false):
	if not first_launch:
		$Tween.interpolate_property(self, "color:a", 1, 0, 3, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$Tween.start()
	else:
		$Tween.interpolate_property($Label, "custom_colors/font_color:a", 0, 1, 2,\
				Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$Tween.start()
		yield($Tween, "tween_all_completed")
		set_process(true)


func close() -> void:
	$Tween.interpolate_property(self, "color:a", 0, 1, 2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.interpolate_method(self, "_set_audio_level", 0.0, -40, 2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	emit_signal("closing_done")


func _validate_open() -> void:
	$Tween.interpolate_property(self, "color:a", 1, 0, 3, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Label, "custom_colors/font_color:a", 1, 0, 2,\
				Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()


func _set_audio_level(level: float) -> void:
	AudioServer.set_bus_volume_db(0, level)
