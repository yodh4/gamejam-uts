extends Node2D

@export var obstacle : PackedScene
@export var spawn_time : int = 5

func _ready():
	repeat()

func spawn():
	var spawned = obstacle.instantiate()
	get_parent().add_child(spawned)

	var spawn_pos = global_position
	#spawn_pos.x = spawn_pos.x + 300
	spawn_pos.x = spawn_pos.x + randi_range(1,300)

	spawned.global_position = spawn_pos

func repeat():
	spawn()
	await get_tree().create_timer(spawn_time).timeout
	repeat()
