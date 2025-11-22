class_name Stats
extends Resource

enum BuffableStats {
    MAX_HEALTH,
    DEFENSE,
    ATTACK,
}

const STAT_CURVES: Dictionary[BuffableStats, Curve] = {
    BuffableStats.MAX_HEALTH: preload("uid://e1gqoitdtdf5"),
    BuffableStats.DEFENSE: preload("uid://s8t2oyayvrga"),
    BuffableStats.ATTACK: preload("uid://dk30ge0ie8tga"),
}

const BASE_LEVEL_XP: float = 100.0

signal health_depleted
signal health_changed(current_health: int, max_health: int)

@export var base_max_health: int = 100
@export var base_defense: int = 10
@export var base_attack: int = 10
@export var experience: int = 0: set = _on_experience_set

var current_max_health: int = 100
var current_defense: int = 10
var current_attack: int = 10
var level: int: get = _get_level

var health: int = 0: set = _on_health_set

func _init() -> void:
    print_debug("_init base_max_health: ", base_max_health)
    setup_stats.call_deferred()


func recalculate_stats() -> void:
    var recalculate_single_stat := func(value: float, entry: BuffableStats) -> float:
        var curve: Curve = STAT_CURVES[entry]    
        var stats_sample_pos: float = (float(level)/-curve.max_domain) - 0.01
        return value * curve.sample(stats_sample_pos)
    current_max_health = recalculate_single_stat.call(current_max_health, BuffableStats.MAX_HEALTH)
    current_defense = recalculate_single_stat.call(current_defense, BuffableStats.DEFENSE)
    current_attack = recalculate_single_stat.call(current_attack, BuffableStats.ATTACK)


func setup_stats() -> void:
    print_debug("call_deferred base_max_health: ", base_max_health)
    recalculate_stats()
    health = current_max_health


func _get_level() -> int:
    var float_value: float = max(1.0, sqrt(experience/BASE_LEVEL_XP) + 0.5)
    return floor(float_value)


func _on_experience_set(new_value: int) -> void:
    var old_level: int = level
    experience = new_value if new_value>0 else 0
    if not old_level == level:
        recalculate_stats()


func _on_health_set(new_value: int) -> void:
    health = clampi(new_value, 0, current_max_health)
    health_changed.emit(health, current_max_health)
    if health <= 0:
        health_depleted.emit()
