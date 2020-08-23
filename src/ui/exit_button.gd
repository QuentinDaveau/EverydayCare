extends TextureButton


func _on_ExitButton_pressed() -> void:
	owner.get_parent().get_node("SaveManager").notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
