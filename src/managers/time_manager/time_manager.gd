extends Node

signal time_update(life_time, flower_time)
signal game_state_update(loose)

const FLOWER_DURATION : int = 93600
const LIFE_DURATION : int = 432000

export(NodePath) var _ui_path

onready var _ui = get_node(_ui_path)

var _flower_time_left: int = 0
var _life_time_left: int = 0
var _sec_spent: float = 0
var _flower_watering: bool = false


func _enter_tree() -> void:
	set_process(false)


func _ready() -> void:
	get_parent().get_node("Character").connect("watering_flower", self, "_on_flower_watering")


func _process(delta: float) -> void:
	_sec_spent += delta
	if _sec_spent >= 1:
		var sec_lost = int(floor(_sec_spent))
		if not _flower_watering:
			_flower_time_left -= sec_lost
		_life_time_left -= sec_lost
		_sec_spent = fmod(_sec_spent, 1)
		_check_time_left()


func load_time(data: Dictionary) -> void:
	var time_spent = OS.get_unix_time() - data["save_time"]
	_flower_time_left = data["flower_left"] - time_spent
	_life_time_left = data["life_left"] - time_spent
	if _check_time_left():
		set_process(true)


func first_launch() -> void:
	_flower_time_left = FLOWER_DURATION
	_life_time_left = LIFE_DURATION
	set_process(true)


func get_flower_left() -> int:
	return _flower_time_left


func get_life_left() -> int:
	return _life_time_left


func get_total_life_duration() -> int:
	return LIFE_DURATION


func _on_flower_watering() -> void:
	$Tween.interpolate_method(self, "set_flower_time", _flower_time_left,\
			FLOWER_DURATION, 3.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	_flower_watering = true
	$Tween.start()
	yield($Tween, "tween_all_completed")
	yield(get_tree().create_timer(2), "timeout")
	_flower_watering = false


func set_flower_time(value: int) -> void:
	if _flower_time_left == value:
		return
	_flower_time_left = value
	_check_time_left()


func _check_time_left() -> bool:
	if _flower_time_left <= 0 or _life_time_left <= 0:
		set_process(false)
		emit_signal("game_state_update", _flower_time_left <= 0)
		_life_time_left = 0
	emit_signal("time_update", _life_time_left, _flower_time_left)
	return _life_time_left > 0
