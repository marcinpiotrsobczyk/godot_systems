extends Node


var _is_fullscreen_menu_on: bool = false


func is_fullscreen_menu_on() -> bool:
    return _is_fullscreen_menu_on


func set_fullscreen_menu_on(on: bool) -> void:
    _is_fullscreen_menu_on = on
