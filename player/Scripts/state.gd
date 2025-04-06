class_name State extends Node

# Stores a reference to the player that this State belongs to
static var player : Player
static var state_machine :  PlayerStateMachine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func init() -> void:
	pass

func enter() -> void:
	pass

func exit() -> void:
	pass

func process(delta : float) -> State:
	return null

func physics(delta : float) -> State:
	return null

func handle_input(event : InputEvent) -> State:
	return null
