extends Spatial

signal watering_flower


enum STATES {sleeping, waking, walking, watering, sitting}

export(float) var _forward_speed: float = 0.35
export(NodePath) var _cane_path

onready var _anim_state = $AnimationTree["parameters/playback"]
onready var _cane = get_node(_cane_path)

var _state: int = STATES.sleeping
var _direction: int = 0
var _cant_go_dir: int = 0

var _alive: bool = true


func _ready() -> void:
	get_parent().get_node("TimeManager").connect("game_state_update", self, "_on_game_state_update")


func _process(delta: float) -> void:
	match _state:
		STATES.sleeping:
			if _alive:
				if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
					_state = STATES.waking
					_anim_state.travel("Waking")
				$AnimationTree.advance(delta)
			return
		STATES.walking:
			if _alive:
				_direction = 0
				if Input.is_action_pressed("ui_left"):
					_direction -= 1
				if Input.is_action_pressed("ui_right"):
					_direction += 1
			else:
				_direction = -1
				if _cant_go_dir == -1:
					sit()
			if _cant_go_dir == _direction:
				continue
			if _direction != 0:
				$Sprite.rotation.y = (_direction * PI / 2) - PI/2
				$AnimationTree.advance(delta)
	if _state != STATES.walking and _state != STATES.sleeping:
		$AnimationTree.advance(delta)


func sit() -> void:
	_state = STATES.sitting
	_anim_state.travel("Sitting")
	if _cane:
		_cane.visible = true


func left_chair() -> void:
	_cant_go_dir = 0


func left_table() -> void:
	_cant_go_dir = 0


func entered_table() -> void:
	_anim_state.travel("Watering")
	_state = STATES.watering


func move_forward() -> void:
	$Tween.interpolate_property(self, "translation:x", translation.x,\
			translation.x + _forward_speed * _direction, 0.1,\
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()


func transit_from_waking() -> void:
	yield(get_tree().create_timer(0.05), "timeout")
	_state = STATES.walking
	if _cane:
		_cane.visible = false
	_cant_go_dir = -1


func transit_from_sitting() -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	_state = STATES.sleeping


func transit_from_watering() -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	_state = STATES.walking
	_cant_go_dir = 1


func _on_game_state_update(loose: bool) -> void:
	_alive = false
