class_name Enemy extends CharacterBody2D

signal direction_changed(new_direction: Vector2)
signal enemy_damaged(hurt_box : HurtBox)
signal enemy_destroyed(hurt_box : HurtBox)

@export var enemy_type : String

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

@export var hp : int = 3

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var invulnerable : bool = false
var player : Player

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var hit_box : HitBox = $HitBox
@onready var state_machine : EnemyStateMachine = $EnemyStateMachine


# Called when the node enters the scene tree for the first time.
func _ready():
	print("👹 Monster siap:", self.name, "at", global_position)
	state_machine.initialize(self)
	player = PlayerManager.player
	add_to_group("enemy")
	hit_box.damaged.connect(take_damage)
	
	#print("👹 [READY] Monster", self.name, "pos sebelum state_machine:", global_position)
	#player = PlayerManager.player
	#add_to_group("enemy")
	#hit_box.damaged.connect(take_damage)
#
	#await get_tree().process_frame
	#print("👣 [AFTER FRAME] Posisi monster:", global_position)
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	pass

func _physics_process(delta: float) -> void:
	move_and_slide()

func set_direction(new_direction : Vector2) -> bool:
	direction = new_direction
	if direction == Vector2.ZERO:
		return false
	
	var direction_id : int = int(round(
			(direction + cardinal_direction * 0.1).angle() 
			/ TAU * DIR_4.size()
	))
	var new_dir = DIR_4[direction_id]
	
	if new_dir == cardinal_direction:
		return false
		
	cardinal_direction = new_dir
	direction_changed.emit(new_dir)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true

func update_animation(state : String) -> void:
	if state == "destroyed":
		PlayerManager.enemies_killed += 1
		animation_player.play(state)
	animation_player.play(state + "_" + anim_direction())
	pass

func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

func take_damage(hurt_box : HurtBox) -> void:
	if invulnerable == true:
		return
	hp -= hurt_box.damage
	if hp > 0:
		enemy_damaged.emit(hurt_box)
	else:
		enemy_destroyed.emit(hurt_box)
