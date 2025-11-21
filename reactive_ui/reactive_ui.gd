extends Control

var selected_hero: ReactiveObject = ReactiveObject.new(null)

func _ready() -> void:
    AudioServer.lock()
    save_game()
    setup_traditional_menu()
 

func save_game() -> void:
    SaveGame.new().example_save()


func setup_traditional_menu() -> void:
    var lambda := func() -> void:
        var value = $TraditionalMenu/TraditionalTextEdit.text
        $TraditionalMenu/TraditionalLabel.text = value
    $TraditionalMenu/TraditionalTextEdit.text_changed.connect(lambda)
