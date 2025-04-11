extends LinkButton

@onready var main_menu: LinkButton = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu.pressed.connect(to_main_menu)

func to_main_menu() -> void:
		get_tree().change_scene_to_file("res://GUI/main_menu/main_menu.tscn")
