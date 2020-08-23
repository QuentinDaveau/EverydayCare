extends Control

var _life_clock: Label
var _flower_clock: Label


func _ready() -> void:
	_life_clock = $MarginContainer/HBoxContainer/MarginContainer/HBoxContainer/LifeClock
	_flower_clock = $MarginContainer/HBoxContainer/MarginContainer2/HBoxContainer/FlowerClock
	get_parent().get_node("TimeManager").connect("time_update", self, "_update_time")


func _update_time(life_time, flower_time) -> void:
	if not _life_clock:
		return
	_life_clock.text = _generate_text(life_time)
	if not life_time:
		_flower_clock.text = _generate_text(0)
		return
	_flower_clock.text = _generate_text(flower_time)
	if not $ClickSound.playing:
		$ClickSound.play()


func _generate_text(time) -> String:
	var text := ""
	var hour := int(floor(time / 3600))
	var minute := int(floor(time / 60)) % 60
	var sec := int(time % 60)
	text += String(hour / 10) + String(hour % 10)
	text += ":" + String(minute / 10) + String(minute % 10)
	text += ":" + String(sec / 10) + String(sec % 10)
	return text
