extends Spatial

var _is_init: bool = true


func _ready() -> void:
	yield(get_tree().create_timer(1), "timeout")
	_is_init = false


func _on_Area_area_entered(area: Area) -> void:
	if _is_init:
		return
	if area.owner.has_method("sit"):
		area.owner.sit()


func _on_Area_area_exited(area: Area) -> void:
	if area.owner.has_method("left_chair"):
		area.owner.left_chair()
