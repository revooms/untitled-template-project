extends Control

@onready var screen_label = %PlayerViewLabel

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
	var cam = Game.get_camera()
	var camera = cam["camera"]
	var cameraPivot = cam["camera_pivot"]
	var output_text = "ROT:X:%.2f/Y:%.2f/Z:%.2f" % [camera.rotation.x, cameraPivot.rotation.y, cameraPivot.rotation.z]
	screen_label.text = output_text
