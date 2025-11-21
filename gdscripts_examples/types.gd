class_name Types
extends MainLoop

func _init() -> void:
    var thing := 'Hi!'
    var thing2: String = 'Hi2!'
    var thing3: String
    var thing4
    #thing = 5
    print(thing)
    print(thing2)
    print(thing3)
    print(thing3.length())
    print(thing4)
    var thing5 := Something.new()
    thing5.internal = weakref(thing5)

class Something:
    var internal: Variant
