extends Node

const SAVE_PATH = "user://"

signal game_saved
signal game_loaded

var pending_load := false

var current_save : Dictionary = {
	player = {
		hp = 1,
		max_hp = 1,
		pos_x = 0,
		pos_y = 0,
		enemies_killed = 0,
		duration_survived = 0,
	},
	monsters = []
}

func get_save_file() -> FileAccess:
	return FileAccess.open(SAVE_PATH + "save.sav", FileAccess.READ)

func save_game():
	update_player_data()
	update_monsters_data()
	var file := FileAccess.open(SAVE_PATH + "save.sav", FileAccess.WRITE)
	var save_json = JSON.stringify(current_save)
	file.store_line(save_json)
	game_saved.emit()
	pass

func load_game():
	print("⚠️ GameManager.load_game() DIPANGGIL")
	var file := FileAccess.open(SAVE_PATH + "save.sav", FileAccess.READ)
	var json := JSON.new()
	json.parse(file.get_line())
	var save_dict : Dictionary = json.data as Dictionary
	current_save = save_dict
	
	PlayerManager.set_player_position(Vector2(
		current_save.player.pos_x,
		current_save.player.pos_y)
	)
	PlayerManager.set_health(current_save.player.hp, current_save.player.max_hp)
	PlayerManager.duration_survived = current_save.player.duration_survived
	PlayerManager.enemies_killed = current_save.player.enemies_killed
	game_loaded.emit()
	pending_load = true
	pass

func update_player_data():
	var p : Player = PlayerManager.player
	current_save.player.hp = p.hp
	current_save.player.max_hp = p.max_hp
	current_save.player.pos_x = p.global_position.x
	current_save.player.pos_y = p.global_position.y
	current_save.player.enemies_killed = PlayerManager.enemies_killed
	current_save.player.duration_survived = PlayerManager.duration_survived

func prepare_load_game():
	var file := FileAccess.open(SAVE_PATH + "save.sav", FileAccess.READ)
	var json := JSON.new()
	json.parse(file.get_line())
	var save_dict : Dictionary = json.data as Dictionary
	current_save = save_dict
	pending_load = true
	
func update_monsters_data():
	current_save.monsters = []  # Reset list monster

	for enemy in get_tree().get_nodes_in_group("enemy"):
		current_save.monsters.append({
			type = enemy.enemy_type,
			pos_x = enemy.global_position.x,
			pos_y = enemy.global_position.y
		})

func load_monsters():
	for monster_data in current_save.monsters:
		var scene_path = "res://Enemies/%s/%s.tscn" % [monster_data.type, monster_data.type]
		print("📦 Loading monster:", scene_path)
		var enemy_scene = load(scene_path)
		if enemy_scene:
			var enemy = enemy_scene.instantiate()
			enemy.global_position = Vector2(monster_data.pos_x, monster_data.pos_y)
			get_tree().current_scene.add_child(enemy)
		else:
			print("❌ Gagal load:", scene_path)
	print("✅ Selesai load", current_save.monsters.size(), "monster(s)")
