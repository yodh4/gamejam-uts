extends Label

@onready var stats_1: Label = $"../stats1"
@onready var stats_2: Label = $"../stats2"
@onready var main_menu: LinkButton = $"../../MainMenu"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stats_1.text = "Duration Survived : " + str(PlayerManager.duration_survived) + " seconds"
	stats_2.text = "Enemies Killed : " + str(PlayerManager.enemies_killed)
