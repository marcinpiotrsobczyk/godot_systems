extends Node

var background_theme: AudioStreamPlayer =  AudioStreamPlayer.new()
var audio_stream_resource: AudioStream = preload("res://assets/dark_mansion_theme.mp3")

const _VOLUME_CHANGE_FACTOR_DB: float = 0.2


func decrease_background_theme_volume() -> void:
	background_theme.volume_db -= _VOLUME_CHANGE_FACTOR_DB

func increase_background_theme_volume() -> void:
	background_theme.volume_db += _VOLUME_CHANGE_FACTOR_DB


func _ready() -> void:
	background_theme.stream = audio_stream_resource
	background_theme.stream.loop = true
	#background_theme.autoplay = true
	add_child(background_theme)
