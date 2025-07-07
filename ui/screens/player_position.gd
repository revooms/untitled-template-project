extends Control

@onready var screen_label = %PlayerPositionLabel

var tick_counter = 0
var tick_interval = 30  # Alle 30 Ticks

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Game.is_running():
		tick_counter += 1
		if tick_counter >= tick_interval:
			tick_counter = 0
			update_ui()

func update_ui() -> void:
	var thePlayer = get_tree().get_nodes_in_group("Players")[0]
	var output_text = "X:%.2f/Y:%.2f/Z:%.2f" % [thePlayer.position.x, thePlayer.position.y, thePlayer.position.z]
	screen_label.text = output_text
