class_name PlayerStateMachine extends Node

var states : Array[State]
var curr_state: State
var prev_state: State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_state(curr_state.process(delta))
	pass
	
func _physics_process(delta: float) -> void:
	change_state(curr_state.physics(delta))
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	change_state(curr_state.handle_input(event))
	pass
	
func initialize(player : Player) -> void:
	states = []
	
	for c in get_children():
		if c is State:
			states.append(c)
	
	if states.size() == 0:
		return
	
	states[0].player = player
	states[0].state_machine = self
	
	for state in states:
		state.init()
	
	change_state(states[0])
	process_mode = Node.PROCESS_MODE_INHERIT
	
func change_state(new_state : State) -> void:
	if new_state == null || new_state == curr_state:
		return
	
	if curr_state:
		curr_state.exit()
	
	prev_state = curr_state
	curr_state = new_state
	curr_state.enter()
