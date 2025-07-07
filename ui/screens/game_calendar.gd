extends Control

@onready var screen_label = %GameCalendarLabel

var tick_counter = 0
var tick_interval = 30  # Alle 30 Ticks

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	tick_counter += 1
	if tick_counter >= tick_interval:
		tick_counter = 0
		update_ui()

func update_ui() -> void:
	var today = Time.get_datetime_string_from_system()
	var cal = GameCalendar.get_date_object(today)
	screen_label.text = cal.datetimestring
