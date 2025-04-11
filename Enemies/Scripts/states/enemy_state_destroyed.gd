class_name EnemyStateDestroyed extends EnemyState

@export var anim_name : String = "destroyed"
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0

@export_category("AI")

var damage_position : Vector2
var direction : Vector2

## What happend when we initialize this State
func init() -> void:
	enemy.enemy_destroyed.connect(on_enemy_destroyed)
	pass

## What happens when the enemy enter this State
func enter() -> void:
	enemy.invulnerable = true
	direction = enemy.global_position.direction_to(damage_position)
	enemy.set_direction(direction)
	enemy.velocity = direction * -knockback_speed
	enemy.update_animation(anim_name)
	enemy.animation_player.animation_finished.connect(on_animation_finished)
	disable_hurt_box()
	pass
	
## What happens when the enemy exit this State
func exit() -> void:
	pass
	
## What happens during the _process update in this State
func process(delta : float) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * delta
	return null

## What happens during the _physics_process update in this State
func physics(delta : float) -> EnemyState:
	return null

func on_enemy_destroyed(hurt_box : HurtBox) -> void:
	damage_position = hurt_box.global_position
	state_machine.change_state(self)
	pass
	
func on_animation_finished(_a : String) -> void:
	enemy.queue_free()

func disable_hurt_box() -> void:
	var hurt_box : HurtBox = enemy.get_node_or_null("HurtBox")
	if hurt_box:
		hurt_box.monitoring = false
