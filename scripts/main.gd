extends Node3D

@onready var ui: CanvasLayer = $UI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Main ready")
	ui.fadeScreenIn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Input.is_key_pressed(KEY_ESCAPE)):
		Game.set_paused()
