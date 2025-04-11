extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.text = "Enemies Killed : " + str(PlayerManager.enemies_killed)
