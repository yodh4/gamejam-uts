extends Node2D

@export var obstacle : PackedScene
@export var spawn_time : int = 5
@export var max_enemies : int = 40

func _ready():
	repeat()

func spawn():
	if get_tree().get_nodes_in_group("enemy").size() >= max_enemies:
		return

	var spawned = obstacle.instantiate()
	get_parent().add_child(spawned)

	var spawn_pos = global_position
	spawn_pos.x = spawn_pos.x + randi_range(1,300)

	spawned.global_position = spawn_pos

func repeat():
	print("Enemies detected: ", get_tree().get_nodes_in_group("enemy").size())
	spawn()
	await get_tree().create_timer(spawn_time).timeout
	repeat()
