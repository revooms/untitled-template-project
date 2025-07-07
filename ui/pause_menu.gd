extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_exit_game_button_pressed() -> void:
	Game.QuitApplication()

func _on_resume_game_button_pressed() -> void:
	Game.set_running()
