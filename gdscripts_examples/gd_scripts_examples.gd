extends Control

@warning_ignore("unused_signal")
signal a_custom_signal

func _ready() -> void:
    AudioServer.lock()
    save_game()
    example_print_info()
 

func save_game() -> void:
    SaveGame.new().example_save()


func example_print_info() -> void:
    _print_object_info(self, "self")
    add_user_signal("a_custom_signal2")
    _print_object_info(self, "self")
    _print_object_info(get_script(), "get_script()")
    get_script().add_user_signal("a_custom_signal3")
    _print_object_info(get_script(), "get_script()")
    _print_object_info(self, "self")
    _print_object_info(SaveGame.new(), "SaveGame")
    _print_object_info(MainLoop.new(), "custom MainLoop")
    _print_object_info(get_tree(), "get_tree()")


func _print_object_info(object, description):
    var signal_names: Array[String] = []
    for signal_info in object.get_signal_list():
        signal_names.append(signal_info["name"])
    print("signal_names of %s: %s" % [description, str(signal_names)])
    var format := [description, type_string(typeof(object)), description, object.get_instance_id()]
    print("type of %s: %s, id of %s: %s" % format)
    print()
