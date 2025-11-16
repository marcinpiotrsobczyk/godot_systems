extends Node

func _process(_delta) -> void:
    if Input.is_key_pressed(KEY_ESCAPE):
        get_tree().quit()
