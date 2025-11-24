extends Camera3D

@export var rotation_helper: Node3D

var last_physics_process_mouse_position_average: float = 0.0
var last_physics_process_mouse_position_samples: Array[Vector2] = []
const AVERAGE_SAMPLES: int = 5
const CAMERA_ZOOM_SPEED: float = 0.05
const CAMERA_ZOOM_MIN: float = 2.0
const CAMERA_ZOOM_MAX: float = 9.0
const CAMERA_MOVEMENT_SPEED: float = 15.0
const CAMERA_ROTATION_SPEED: float = 3.0

func get_camera_position_y(z: float) -> float:
    return z/2.0 + z*z / 10.0


func get_camera_rotation_x(z: float) -> float:
    return -30.0 - z * 5.0


func handle_camera_zoom(event: InputEvent) -> void:
    var camera_position_difference: Vector3 = global_position - rotation_helper.global_position
    camera_position_difference.y = 0.0
    var camera_distance = camera_position_difference.length()
    if event.is_action_pressed("camera_zoom_out"):
        if camera_distance < CAMERA_ZOOM_MAX:
            position.z += camera_distance *  CAMERA_ZOOM_SPEED
            position.y = get_camera_position_y(position.z)
            rotation_degrees.x = get_camera_rotation_x(position.z)
    elif event.is_action_pressed("camera_zoom_in"):
        if camera_distance > CAMERA_ZOOM_MIN:
            position.z -= camera_distance *  CAMERA_ZOOM_SPEED
            position.y = get_camera_position_y(position.z)
            rotation_degrees.x = get_camera_rotation_x(position.z)


func move_camera(delta: float) -> void:
    var camera_movement: Vector3 = Vector3.ZERO
    if Input.is_action_pressed("camera_forward"):
        camera_movement.z = -delta
    elif Input.is_action_pressed("camera_back"):
        camera_movement.z = delta
    elif Input.is_action_pressed("camera_left"):
        camera_movement.x = -delta
    elif Input.is_action_pressed("camera_right"):
        camera_movement.x = delta
    camera_movement *= CAMERA_MOVEMENT_SPEED
    if camera_movement != Vector3.ZERO:
        var global_movement: Vector3 = to_global(camera_movement) - global_position
        global_movement.y = 0.0
        rotation_helper.position += global_movement


func rotate_camera(delta: float) -> void:
    var rotation_change: float = 0.0
    if Input.is_action_pressed("toggle_camera_rotation"):
        var mouse_position: Vector2 = get_viewport().get_mouse_position()
        if last_physics_process_mouse_position_average != 0.0:
            var mouse_position_delta: float = mouse_position.x - last_physics_process_mouse_position_average
            if mouse_position_delta > 0:
                rotation_change = -1.0
            elif mouse_position_delta < 0:
                rotation_change = 1.0
    else:
        if Input.is_action_pressed("rotate_camera_right"):
            rotation_change = -1.0
        elif Input.is_action_pressed("rotate_camera_left"):
            rotation_change = 1.0
    if rotation_change != 0.0:
        rotation_helper.rotate(Vector3.UP, rotation_change * delta * CAMERA_ROTATION_SPEED)


func update_mouse_position_average() -> void:
    if last_physics_process_mouse_position_samples.size() >= AVERAGE_SAMPLES:
        last_physics_process_mouse_position_samples.pop_front()
    var mouse_position = get_viewport().get_mouse_position()
    last_physics_process_mouse_position_samples.push_back(mouse_position)
    var new_average: float = 0.0
    for sample in last_physics_process_mouse_position_samples:
        new_average += sample.x
    new_average /= AVERAGE_SAMPLES
    last_physics_process_mouse_position_average = new_average


func _ready() -> void:
    position.y = get_camera_position_y(position.z)
    rotation_degrees.x = get_camera_rotation_x(position.z)


func _process(_delta: float) -> void:
    pass


func _physics_process(delta: float) -> void:
    update_mouse_position_average()
    if not GUI.is_fullscreen_menu_on():
        rotate_camera(delta)
        move_camera(delta)


func _unhandled_input(event: InputEvent) -> void:
    if not GUI.is_fullscreen_menu_on():
        handle_camera_zoom(event)
