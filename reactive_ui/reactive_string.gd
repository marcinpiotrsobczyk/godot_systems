class_name ReactiveString
extends Reactive

var value: String:
    set(_value):
        value = _value
        reactive_changed.emit(self)
        return value

func _init(initial_value: String, initial_owner: Reactive = null) -> void:
    super._init(initial_owner)
    value = initial_value
