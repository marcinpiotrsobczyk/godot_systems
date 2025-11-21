class_name Hero
extends Reactive

var name: ReactiveString = ReactiveString.new("Hierofant", self)
var strength: ReactiveInt = ReactiveInt.new(8, self)
var dexterity: ReactiveInt = ReactiveInt.new(16, self)
var constitution: ReactiveInt = ReactiveInt.new(15, self)
var intelligence: ReactiveInt = ReactiveInt.new(8, self)
var wisdom: ReactiveInt = ReactiveInt.new(17, self)
var charisma: ReactiveInt = ReactiveInt.new(8, self)


func _init() -> void:
    super._init()

func randomize_stats() -> void:
    strength.value = randi_range(8, 18)
    dexterity.value = randi_range(8, 18)
    constitution.value = randi_range(8, 18)
    intelligence.value = randi_range(8, 18)
    wisdom.value = randi_range(8, 18)
    charisma.value = randi_range(8, 18)
