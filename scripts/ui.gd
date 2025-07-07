extends CanvasLayer

const FADE_SECONDS = 1

@onready var game_status_label: Label = $GameStatus/MarginContainer/GameStatusLabel
@onready var color_rect: ColorRect = $FadeBlackScreen/ColorRect
@onready var pause_menu: Control = $PauseMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventHub.game_state_changed.connect(_on_game_state_changed)
	paint_game_status()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func paint_game_status() -> void: 
	var output_text = "%s v%s | %s | %s" % [Game.title, Game.version, Game.date_begin, Game.get_state_name()]
	game_status_label.text = output_text
	# Toggle PauseMenu
	if Game.is_paused():
		pause_menu.show()
	else:
		pause_menu.hide()

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
