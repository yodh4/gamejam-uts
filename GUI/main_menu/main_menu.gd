extends Node

@onready var cont: Button = $"../Continue"
@onready var new_game: Button = $"../NewGame"
@onready var quit: Button = $"../Quit"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PauseMenu.process_mode = Node.PROCESS_MODE_DISABLED
	if GameManager.get_save_file() == null:
		cont.disabled = true
	
	await get_tree().process_frame
	setup_screen()
	pass # Replace with function body.

func setup_screen():
	new_game.pressed.connect(start_game)
	cont.pressed.connect(load_game)
	quit.pressed.connect(exit_game)
	pass

func start_game() -> void:
	PlayerManager.enemies_killed = 0
	PlayerManager.duration_survived = 0
	var scene = load("res://MainLevel.tscn")
	var new_scene = scene.instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = new_scene
	PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	pass

func load_game() -> void:
	print("⏳ Loading game...")
	GameManager.prepare_load_game()
	var scene = load("res://MainLevel.tscn")
	var new_scene = scene.instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = new_scene
	PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	pass

func exit_game() -> void:
	get_tree().quit()
	pass
