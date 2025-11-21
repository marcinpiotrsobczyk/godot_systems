class_name ReactiveObject
extends Reactive

var value: Object:
    set(_value):
        if value != null and value is Reactive:
            value.reactive_changed.disconnect(_propagate)
        value = _value
        if value != null and value is Reactive:
            value.reactive_changed.connect(_propagate)
        reactive_changed.emit(self)
        return value


func _init(initial_value: Object, initial_owner: Reactive = null) -> void:
    super._init(initial_owner)
    value = initial_value
