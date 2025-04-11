extends Timer

var time_in_sec : int = 0

@onready var time_survived: Label = get_node("../HBoxContainer/time_survived")

func _ready() -> void:
	GameManager.game_loaded.connect(on_game_loaded)
	time_in_sec = PlayerManager.duration_survived
	update_label()
	start()

func on_game_loaded():
	time_in_sec = PlayerManager.duration_survived
	update_label()

func _on_timeout() -> void:
	time_in_sec += 1
	PlayerManager.duration_survived = time_in_sec
	update_label()

func update_label():
	var minute = int(time_in_sec / 60)
	var second = time_in_sec % 60
	time_survived.text = '%02d:%02d' % [minute, second]
