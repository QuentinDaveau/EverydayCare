extends Node


export(NodePath) var _time_manager_path

onready var _time_manager = get_node(_time_manager_path)


func _ready() -> void:
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		_time_manager.first_launch()
		return 
	save_game.open("user://savegame.save", File.READ)
	_time_manager.load_time(parse_json(save_game.get_line()))
	save_game.close()


func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		prepare_and_save()
		var transit_screen = get_parent().get_node("TransitScreen")
		transit_screen.close()
		yield(transit_screen, "closing_done")
		get_tree().quit()


func prepare_and_save() -> void:
	var save_dict = {"save_time": OS.get_unix_time(), "life_left":\
			_time_manager.get_life_left(), "flower_left": _time_manager.get_flower_left()}
	_save_game(save_dict)


func _save_game(data: Dictionary):
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	save_game.store_line(to_json(data))
	save_game.close()
