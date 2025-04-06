class_name State_Idle extends State

@onready var walk: State_Walk = $"../Walk"
@onready var attack: State_Attack = $"../Attack"


func enter() -> void:
	player.update_animation("idle")
	pass

func exit() -> void:
	pass
	
func process(delta : float) -> State:
	if player.direction != Vector2.ZERO:
		return walk
	player.velocity = Vector2.ZERO
	return null
	
func physics(delta : float) -> State:
	return null
	
func handle_input(event : InputEvent) -> State:
	if event.is_action_pressed("attack"):
		return attack
	return null
