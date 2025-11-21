extends Control

var selected_hero: ReactiveObject = ReactiveObject.new(null)

func _ready() -> void:
    AudioServer.lock()
    setup_traditional_menu()


func setup_traditional_menu() -> void:
    var lambda := func() -> void:
        var value = $TraditionalMenu/TraditionalTextEdit.text
        $TraditionalMenu/TraditionalLabel.text = value
    $TraditionalMenu/TraditionalTextEdit.text_changed.connect(lambda)
