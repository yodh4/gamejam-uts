# hit_box => Area2D for the entity takes damage

class_name HitBox extends Area2D

# Signal emitted when the hit box takes damage.
signal damaged( hurt_box : HurtBox )

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func take_damage( hurt_box : HurtBox ) -> void:
	damaged.emit( hurt_box )
