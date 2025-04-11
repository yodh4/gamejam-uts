class_name State_Attack extends State

var attacking : bool = false

@export var attack_sound : AudioStream
@export_range(1, 20, 0.5) var decelerate_speed : float = 5.0

@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"
@onready var audio : AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"

@onready var walk : State_Walk = $"../Walk"
@onready var idle : State = $"../Idle"
@onready var hurt_box: HurtBox = $"../../Sprite2D/HurtBox"


func enter() -> void:
	print("ENTER ATTACK STATE")
	player.update_animation("attack")
	animation_player.animation_finished.connect(end_attack)
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()
	attacking = true
	
	await get_tree().create_timer(0.075).timeout
	if attacking:
		hurt_box.monitoring = true
	pass

func exit() -> void:
	print("FINISH ATTACK STATE")
	animation_player.animation_finished.disconnect(end_attack)
	attacking = false
	hurt_box.monitoring = false
	pass
	
func process(delta : float) -> State:
	player.velocity -= player.velocity * decelerate_speed * delta 
	
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null
	
func physics(delta : float) -> State:
	return null
	
func handle_input(event : InputEvent) -> State:
	return null

func end_attack(new_animation_name : String) -> void:
	attacking = false
