extends CanvasLayer

@onready var button_load: Button = $HBoxContainer/ButtonLoad
@onready var button_save: Button = $HBoxContainer/ButtonSave
@onready var button: Button = $Button

var is_paused : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_pause_menu()
	button_save.pressed.connect(on_save_pressed)
	button_load.pressed.connect(on_load_pressed)
	button.pressed.connect(on_menu_pressed)
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if is_paused == false:
			show_paused_menu()
		else:
			hide_pause_menu()
		get_viewport().set_input_as_handled()

func show_paused_menu() -> void:
	get_tree().paused = true
	if GameManager.get_save_file() == null:
		button_load.disabled = true
	visible = true
	is_paused = true

func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false

func on_save_pressed():
	if !is_paused:
		return
	GameManager.save_game()
	hide_pause_menu()
	pass

func on_load_pressed():
	if !is_paused:
		return
	GameManager.load_game()
	hide_pause_menu()
	pass

func on_menu_pressed():
	if !is_paused:
		return
	get_tree().change_scene_to_file(
		"res://GUI/main_menu/main_menu.tscn"
	)
	hide_pause_menu()
	pass
