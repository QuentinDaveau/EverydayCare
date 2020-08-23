extends ColorRect

signal closing_done

func _ready():
	$Tween.interpolate_property(self, "color:a", 1, 0, 3, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()


func close() -> void:
	$Tween.interpolate_property(self, "color:a", 0, 1, 2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.interpolate_method(self, "_set_audio_level", 0.0, -40, 2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	emit_signal("closing_done")


func _set_audio_level(level: float) -> void:
	AudioServer.set_bus_volume_db(0, level)
