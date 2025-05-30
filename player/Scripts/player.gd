class_name Player extends CharacterBody2D

signal direction_changed(new_direction: Vector2)
signal player_damaged(hurt_box: HurtBox)

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO

var invulnerable: bool = false
var hp: int = 6
var max_hp: int = 6

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var hit_box: HitBox = $HitBox


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("✅ Player ready, pending_load =", GameManager.pending_load)
	PlayerManager.player = self
	state_machine.initialize(self)
	
	hit_box.damaged.connect(take_damage)
	update_hp(99)
	print("🧍 Player pos:", global_position)
	if GameManager.pending_load:
		print("📥 Loading saved state into player")
		var data = GameManager.current_save.player
		PlayerManager.set_health(data.hp, data.max_hp)
		PlayerManager.set_player_position(Vector2(data.pos_x, data.pos_y))
		PlayerManager.duration_survived = data.duration_survived
		PlayerManager.enemies_killed = data.enemies_killed
		GameManager.load_monsters()
		GameManager.pending_load = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()
	pass

func _physics_process(delta: float) -> void:
	move_and_slide()

func set_direction() -> bool:
	if direction == Vector2.ZERO:
		return false
	
	var direction_id: int = int(round((direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size()))
	var new_dir = DIR_4[direction_id]
	
	if new_dir == cardinal_direction:
		return false
		
	cardinal_direction = new_dir
	direction_changed.emit(new_dir)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	
	return true
	
func update_animation(state: String) -> void:
	animation_player.play(state + "_" + anim_direction())
	pass
	
func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
		
func take_damage(hurt_box: HurtBox) -> void:
	if invulnerable == true:
		return
	update_hp(-hurt_box.damage)
	if hp > 0:
		player_damaged.emit(hurt_box)
		move_to_safe_spot()
	else:
		get_tree().change_scene_to_file(str("res://GUI/game_over/game_over.tscn"))
	pass

func update_hp(delta: int) -> void:
	hp = clampi(hp + delta, 0, max_hp)
	pass

func make_invulnerable(duration: float = 3.0) -> void:
	invulnerable = true
	hit_box.monitoring = false
	
	await get_tree().create_timer(duration).timeout
	invulnerable = false
	hit_box.monitoring = true
	pass

func move_to_safe_spot() -> void:
	var camera_limits = {
		"left": 0,
		"top": 0,
		"right": 1155, 
		"bottom": 660    
	}
	var margin = 60

	var map_bounds = Rect2(
		camera_limits.left + margin,
		camera_limits.top + margin,
		camera_limits.right - camera_limits.left - margin * 2,
		camera_limits.bottom - camera_limits.top - margin * 2
	)
	var step = 100
	var safe_pos = global_position
	var min_enemies = 9999

	for x in range(map_bounds.position.x, map_bounds.end.x, step):
		for y in range(map_bounds.position.y, map_bounds.end.y, step):
			var pos = Vector2(x, y)
			var count = 0
			for enemy in get_tree().get_nodes_in_group("enemy"):
				if enemy.global_position.distance_to(pos) < 100:
					count += 1
			if count < min_enemies:
				min_enemies = count
				safe_pos = pos
	
	safe_pos.x = clamp(safe_pos.x, camera_limits.left, camera_limits.right)
	safe_pos.y = clamp(safe_pos.y, camera_limits.top, camera_limits.bottom)
	global_position = safe_pos
	
	var camera = $Camera2D
	if camera:
		camera.make_current()
		print("Moved player to safe spot at", global_position, "with", min_enemies, "enemies nearby")
