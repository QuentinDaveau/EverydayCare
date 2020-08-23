extends Node


export(NodePath) var _flower_path

var _flower


func _ready() -> void:
	get_parent().get_node("TimeManager").connect("time_update", self, "_update_flower")
	_flower = get_node(_flower_path)


func _update_flower(time_left: int, flower_left: int) -> void:
	if time_left <= 0:
		_flower.frame = 10
	else:
		_flower.frame = 10 - (ceil(time_left / 43200) + 1)
