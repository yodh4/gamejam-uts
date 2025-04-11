extends Node

var player : Player

var enemies_killed : int = 0
var duration_survived : int = 0

func set_health( hp: int, max_hp: int ) -> void:
	player.max_hp = max_hp
	player.hp = hp
	player.update_hp( 0 )

func set_player_position( new_pos : Vector2 ) -> void:
	player.global_position = new_pos
	pass
