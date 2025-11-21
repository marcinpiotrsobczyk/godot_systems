class_name ReactiveInt
extends Reactive

var value: int:
    set(_value):
        value = _value
        reactive_changed.emit(self)
        return value


func _init(initial_value: int, initial_owner: Reactive = null) -> void:
    super._init(initial_owner)
    value = initial_value
