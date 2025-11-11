extends Node

var background_theme: AudioStreamPlayer =  AudioStreamPlayer.new()
var audio_stream_resource: AudioStream = preload("res://assets/dark_mansion_theme.mp3")

const _VOLUME_CHANGE_FACTOR_DB: float = 2.0
const _VOLUME_VALUE_SENSITIVITY: float = 5.0


func decrease_background_theme_volume(times: int = 1) -> void:
	for i in range(times):
		background_theme.volume_db -= _VOLUME_CHANGE_FACTOR_DB


func increase_background_theme_volume(times: int = 1) -> void:
	for i in range(times):
		background_theme.volume_db += _VOLUME_CHANGE_FACTOR_DB


func set_background_theme_volume(value: float = 0.0) -> void:
	background_theme.volume_db = value/_VOLUME_VALUE_SENSITIVITY


func disable_background_theme_volume() -> void:
	background_theme.stream_paused = true


func enable_background_theme_volume() -> void:
	background_theme.stream_paused = false


func _ready() -> void:
	background_theme.stream = audio_stream_resource
	background_theme.stream.loop = true
	background_theme.autoplay = true
	add_child(background_theme)
