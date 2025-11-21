extends RefCounted
class_name SaveGame

class MyResource:
    extends Resource
    @export var value = 5
    func _init(p_value) -> void:
        value = p_value

class CustomField:
    var value
    func _init(p_value) -> void:
        value = p_value

func example_save() -> void:
    var my_custom_resource = MyResource.new(12)
    ResourceSaver.save(my_custom_resource, "user://my_custom_resource.tres")
    var my_custom_resource2 = MyResource.new(13)
    ResourceSaver.save(my_custom_resource2, "user://my_custom_resource2.tres")
    var my_custom_config_file = ConfigFile.new()
    my_custom_config_file.set_value("somesection", "somekey", "somevalue")
    my_custom_config_file.set_value("somesection", "somevector", Vector2i(12, 13))
    my_custom_config_file.set_value("somesection", "someothervector", Vector2(14, 15))
    my_custom_config_file.set_value("somesection", "customkey2", CustomField.new(123))
    my_custom_config_file.save("user://my_custom_config_file_plain_text.tres")
    my_custom_config_file.save_encrypted_pass("user://my_custom_config_file_encrypted.tres", "apple")   
