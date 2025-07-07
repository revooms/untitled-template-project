extends Node

@export var author: String = "IkoTikashi"
@export var date_begin: String = "2025-06-07"
@export var version: String = "0.1"

var state: Enums.GameState = Enums.GameState.WARMUP
var title: String = "Untitled Game"

func _ready() -> void:
	title = ProjectSettings.get_setting("application/config/name")
	set_warmup()
	Logger.out(self, "Ready")

func set_state(newstate: Enums.GameState) -> void:
	state = newstate
	EventHub.game_state_changed.emit(state)

func set_warmup() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED	
	set_state(Enums.GameState.WARMUP)

func set_paused() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	set_state(Enums.GameState.PAUSED)

func set_running() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	set_state(Enums.GameState.RUNNING)

func set_shutdown() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	set_state(Enums.GameState.SHUTDOWN)

func get_state() -> Enums.GameState:
	return state

func get_state_name() -> String:
	return str(Enums.GameState.keys()[state])
	
func is_running() -> bool:
	return state == Enums.GameState.RUNNING
	
func is_paused() -> bool:
	return state == Enums.GameState.PAUSED
	
func QuitApplication() -> void:
	set_shutdown()
	GameSave.save_game()
	get_tree().quit()

func get_player() -> Node3D:
	var player_data
	if not get_tree().get_nodes_in_group("Players").is_empty():
		player_data = get_tree().get_nodes_in_group("Players")[0]
	else:
		player_data = get_node("Player")
	
	return player_data


func get_player_node() -> Node3D:
	var player_data = get_tree().get_first_node_in_group("Players")
	return player_data

func get_camera() -> Dictionary:
	var camera = get_viewport().get_camera_3d()
	var cameraPivot = camera.get_parent_node_3d().get_parent_node_3d().get_parent_node_3d()
	
	return {
		"camera": camera,
		"camera_pivot": cameraPivot,
	}
	
func get_persistant_object() -> Dictionary:
	return {
		"author": self.author,
		"date_begin": self.date_begin,
		"version": self.version,
	}
