extends CanvasLayer

const FADE_SECONDS = 1

@onready var game_status_label: Label = $GameStatus/MarginContainer/GameStatusLabel
@onready var color_rect: ColorRect = $FadeBlackScreen/ColorRect
@onready var pause_menu: Control = $PauseMenu

@onready var label_calendar: Control = %InfoItemsContainer/GameCalendar/%GameCalendarLabel
@onready var label_player_position: Control = %InfoItemsContainer/PlayerPosition/%PlayerPositionLabel
@onready var label_player_view: Control = %InfoItemsContainer/PlayerView/%PlayerViewLabel
@onready var label_player_info: Control = %InfoItemsContainer/PlayerInfo/%PlayerInfoLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventHub.game_state_changed.connect(_on_game_state_changed)
	paint_game_status()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	paint_player_position()
	paint_player_view()
	paint_player_info()

func paint_game_status() -> void: 
	var output_text = "%s v%s | %s | %s" % [Game.title, Game.version, Game.date_begin, Game.get_state_name()]
	game_status_label.text = output_text
	# Toggle PauseMenu
	if Game.is_paused():
		pause_menu.show()
	else:
		pause_menu.hide()

func paint_player_position() -> void:
	var thePlayer = get_tree().get_nodes_in_group("Players")[0]
	var output_text = "X:%.2f/Y:%.2f/Z:%.2f" % [thePlayer.position.x, thePlayer.position.y, thePlayer.position.z]
	label_player_position.text = output_text

func paint_player_view() -> void:
	#var thePlayer = get_tree().get_nodes_in_group("Players")[0]
	var currentCamera = get_viewport().get_camera_3d()
	var cameraPivot = currentCamera.get_parent_node_3d().get_parent_node_3d().get_parent_node_3d()
	var output_text = "ROT:X:%.2f/Y:%.2f/Z:%.2f" % [currentCamera.rotation.x, cameraPivot.rotation.y, cameraPivot.rotation.z]
	label_player_view.text = output_text

func paint_player_info() -> void:
	var thePlayer = get_tree().get_nodes_in_group("Players")[0]
	var output_text = "T:%d F:%d A:%d JUMPS:%d" % [thePlayer.distance_travelled, thePlayer.distance_travelled_on_floor, thePlayer.distance_travelled_in_air, thePlayer.times_jumped]
	label_player_info.text = output_text

func _on_game_state_changed(_changed_state) -> void:
	paint_game_status()

func fadeScreenIn() -> void:
	var tween = get_tree().create_tween().tween_property(color_rect, "color", Color(0,0,0,0), FADE_SECONDS)
	await tween.finished
	color_rect.hide()
	Game.set_running()

func fadeScreenOut() -> PropertyTweener:
	color_rect.color = Color(0,0,0,0)
	color_rect.show()
	var tween = get_tree().create_tween().tween_property(color_rect, "color", Color(0,0,0,1), FADE_SECONDS)
	return tween
