extends Node3D

@onready var ui: CanvasLayer = $UI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Logger.out(self, "Ready")
	ui.fadeScreenIn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if (Input.is_action_just_pressed("pause")):
		if Game.is_paused():
			Game.set_running()
		else:
			Game.set_paused()
