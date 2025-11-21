class_name PartyMenu
extends Control

var selected_hero: ReactiveObject = ReactiveObject.new(null)
const ALPHA_DISABLED: float = 0.2
const ALPHA_ENABLED: float = 1.0

func _ready() -> void:
    setup_party_menu()


func setup_party_menu() -> void:
    %AvailableList.selection = selected_hero
    %HiredList.selection = selected_hero
    State.available_heroes.reactive_changed.connect(_rebuild_available)
    State.hired_heroes.reactive_changed.connect(_rebuild_hired)
    %EditName.text_changed.connect(_change_name)
    %HireButton.pressed.connect(_hire)
    %RemoveButton.pressed.connect(_remove)
    selected_hero.reactive_changed.connect(_selected_hero_changed)
    State.available_heroes.manually_emit()
    State.hired_heroes.manually_emit()
    selected_hero.value = null


func _rebuild_available(heroes: ReactiveArray) -> void:
    %AvailableList.rebuild_from_list(heroes.value, selected_hero.value)


func _rebuild_hired(heroes: ReactiveArray) -> void:
    %HiredList.rebuild_from_list(heroes.value, selected_hero.value)


func _change_name() -> void:
    var text: String = %EditName.text
    if selected_hero.value != null:
        selected_hero.value.name.value = text


func _hire() -> void:
    State.available_heroes.erase(selected_hero.value)
    State.hired_heroes.append(selected_hero.value)


func _remove() -> void:
    State.hired_heroes.erase(selected_hero.value)
    State.available_heroes.append(selected_hero.value)


func _selected_hero_changed(reactive) -> void:
    var caret = %EditName.get_caret_column()
    %EditName.text = reactive.value.name.value if reactive.value != null else ""
    %EditName.set_caret_column(caret)

    var check_disable_selected := func(new_selected: Reactive) -> void:
        var enabled_selected: bool = new_selected.value != null
        %Selected.modulate.a = ALPHA_ENABLED if enabled_selected else ALPHA_DISABLED
        %EditName.editable = enabled_selected

    var check_disable_buttons := func(new_selected: Reactive) -> void:
        var enabled_hire: bool = new_selected != null and State.available_heroes.has(new_selected.value)
        %HireButton.modulate.a = ALPHA_ENABLED if enabled_hire else ALPHA_DISABLED
        %HireButton.disabled = !enabled_hire
        %HireButton.focus_mode = Control.FOCUS_ALL if enabled_hire else Control.FOCUS_NONE
        var enabled_remove: bool = new_selected != null and State.hired_heroes.has(new_selected.value)
        %RemoveButton.modulate.a = ALPHA_ENABLED if enabled_remove else ALPHA_DISABLED
        %RemoveButton.disabled = !enabled_remove
        %RemoveButton.focus_mode = Control.FOCUS_ALL if enabled_remove else Control.FOCUS_NONE

    if reactive.value != null:
        var attr_str := func(attr: ReactiveInt) -> String:
            return str(attr.value).pad_zeros(2)
        %Strength.text = attr_str.call(reactive.value.strength)
        %Dexterity.text = attr_str.call(reactive.value.dexterity)
        %Constitution.text = attr_str.call(reactive.value.constitution)
        %Intelligence.text = attr_str.call(reactive.value.intelligence)
        %Wisdom.text = attr_str.call(reactive.value.wisdom)
        %Charisma.text = attr_str.call(reactive.value.strength)
    check_disable_selected.call(reactive)
    check_disable_buttons.call(reactive)
