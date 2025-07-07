extends Node3D

@export var audio_file: AudioStream
@export var auto_play: bool = false

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player_3d.stream = audio_file
	if auto_play:
		audio_stream_player_3d.play()
