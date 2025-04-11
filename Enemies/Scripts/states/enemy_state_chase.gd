class_name EnemyStateChase extends EnemyState

@export var anim_name : String = "walk"
@export var chase_speed : float = 40.0
@export var turn_rate : float = 0.5

@export_category("AI")
@export var state_aggro_duration : float = 0.5
@export var next_state : EnemyState
@export var vision_area : VisionArea
@export var attack_area : HurtBox

var timer : float = 0.0
var direction : Vector2
var can_see_player : bool = false

## What happend when we initialize this State
func init() -> void:
	if vision_area:
		vision_area.player_entered.connect(on_player_entered)
		vision_area.player_exited.connect(on_player_exited)
	pass

## What happens when the enemy enter this State
func enter() -> void:
	timer = state_aggro_duration
	enemy.update_animation(anim_name)
	can_see_player = true
	if attack_area:
		attack_area.monitoring = true
	pass
	
## What happens when the enemy exit this State
func exit() -> void:
	if attack_area:
		attack_area.monitoring = false
	can_see_player = false
	pass
	
## What happens during the _process update in this State
func process(delta : float) -> EnemyState:
	var new_dir : Vector2 = enemy.global_position.direction_to(
							PlayerManager.player.global_position)
	direction = lerp(direction, new_dir, turn_rate)
	enemy.velocity = direction * chase_speed
	
	if enemy.set_direction(direction):
		enemy.update_animation(anim_name)
	
	if can_see_player == false:
		timer -= delta
		if timer < 0:
			return next_state
	else:
		timer = state_aggro_duration
	return null

## What happens during the _physics_process update in this State
func physics(delta : float) -> EnemyState:
	return null

func on_player_entered() -> void:
	can_see_player = true
	if (
		state_machine.current_state is EnemyStateStun or 
		state_machine.current_state is EnemyStateDestroyed
		):
		return
	state_machine.change_state(self)
	pass

func on_player_exited() -> void:
	can_see_player = false
	pass
