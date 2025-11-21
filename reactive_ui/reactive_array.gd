class_name ReactiveArray
extends Reactive

var value: Array:
    set(_value):
        value = _value
        reactive_changed.emit(self)
        return value


func _init(initial_value: Array = [], initial_owner: Reactive = null) -> void:
    super._init(initial_owner)
    value = initial_value


func get_at(index: int) -> Variant:
    return value[index]


func set_at(index: int, element: Variant) -> void:
    value[index] = element
    reactive_changed.emit(self)


func append(element: Variant) -> void:
    value.append(element)
    reactive_changed.emit(self)


func assign(array: Array) -> void:
    value.assign(array)
    reactive_changed.emit(self)


func clear() -> void:
    value.clear()
    reactive_changed.emit(self)


func erase(element: Variant) -> void:
    value.erase(element)
    reactive_changed.emit(self)


func has(element: Variant) -> bool:
    return value.has(element)


func insert(index: int, element: Variant) -> void:
    value.insert(index, element)
    reactive_changed.emit(self)


func pop_at(index: int) -> Variant:
    var tmp = value.pop_at(index)
    reactive_changed.emit(self)
    return tmp


func pop_back() -> Variant:
    var tmp = value.pop_back()
    reactive_changed.emit(self)
    return tmp


func pop_front() -> Variant:
    var tmp = value.pop_front()
    reactive_changed.emit(self)
    return tmp


func push_back(element: Variant) -> void:
    value.push_back(element)
    reactive_changed.emit(self)


func remove_at(index: int) -> void:
    value.remove_at(index)
    reactive_changed.emit(self)


func shuffle() -> void:
    value.shuffle()
    reactive_changed.emit(self)


func sort() -> void:
    value.sort()
    reactive_changed.emit(self)


func sort_custom(callable: Callable) -> void:
    value.sort_custom(callable)
    reactive_changed.emit(self)
