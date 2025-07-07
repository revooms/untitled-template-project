extends Control

@onready var screen_label = %LocaltimeLabel

var tick_counter = 0
var tick_interval = 30  # Alle 30 Ticks

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_ui()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	tick_counter += 1
	if tick_counter >= tick_interval:
		tick_counter = 0
		update_ui()

func update_ui() -> void:
	var today = Time.get_time_string_from_system()
	screen_label.text = today
