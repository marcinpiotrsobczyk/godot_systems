extends Node3D

@export var camera: Camera3D


var desired_player_position: Vector3 = Vector3.ZERO
const PLAYER_MOVEMENT_SPEED: float = 3.0


func handle_desired_position(event: InputEventMouseButton) -> void:
    if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
        var raycast_result: Dictionary = shoot_ray()
        if raycast_result.has("position") and raycast_result["position"] is Vector3:
            print_debug("position valid, raycast result: ", raycast_result)
            desired_player_position = raycast_result["position"]
        else:
            print_debug("position invalid, raycast result: ", raycast_result)


func move_player(delta: float) -> void:
    var difference: Vector3 = desired_player_position-global_position
    difference.y = position.y
    if difference.length() > 0.1:
        var new_player_position: Vector3 = global_position
        new_player_position += difference.normalized() * delta * PLAYER_MOVEMENT_SPEED
        global_position = new_player_position


func shoot_ray() -> Dictionary:
    var mouse_position: Vector2 = get_viewport().get_mouse_position()
    var ray_length: float = 1000.0
    var from: Vector3 = camera.project_ray_origin(mouse_position)
    var to: Vector3 = from + camera.project_ray_normal(mouse_position) * ray_length
    var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
    var params: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to)
    params.collide_with_areas = true
    return space_state.intersect_ray(params)


func _process(_delta: float) -> void:
    pass


func _physics_process(delta: float) -> void:
    move_player(delta)


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        handle_desired_position(event)
