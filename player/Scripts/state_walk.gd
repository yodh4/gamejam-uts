class_name State_Walk extends State

@export var move_speed : float = 100.0
@onready var idle: State_Idle = $"../Idle"
@onready var attack: State_Attack = $"../Attack"


func enter() -> void:
	player.update_animation("walk")
	pass

func exit() -> void:
	pass
	
func process(delta : float) -> State:
	if player.direction == Vector2.ZERO:
		return idle
	
	player.velocity = player.direction * move_speed
	
	if player.set_direction():
		player.update_animation("walk")
	
	return null
	
func physics(delta : float) -> State:
	return null
	
func handle_input(event : InputEvent) -> State:
	if event.is_action_pressed("attack"):
		return attack
	return null
