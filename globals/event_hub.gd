extends Node

signal game_state_changed(state)
signal worldsizechanged(oldsize, newsize)

func _ready() -> void:
	self.game_state_changed.connect(_on_emitted)
	self.worldsizechanged.connect(_on_emitted)
	
func _on_emitted(_emitted_signal) -> void:
	#Logger.info(self, "Signal %s has been emitted" % emitted_signal)
	pass
