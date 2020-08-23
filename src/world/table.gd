extends Sprite3D


func _on_Area_area_entered(area: Area) -> void:
	if area.owner.has_method("entered_table"):
		area.owner.entered_table()


func _on_Area_area_exited(area: Area) -> void:
	if area.owner.has_method("left_table"):
		area.owner.left_table()
