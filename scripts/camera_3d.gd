extends Camera3D

@export var rotation_helper: Node3D

var last_physics_process_mouse_position_average: float = 0.0
var last_physics_process_mouse_position_samples: Array[Vector2] = []
var desired_camera_movement: Vector3 = Vector3.ZERO


const AVERAGE_SAMPLES: int = 5
const CAMERA_ZOOM_SPEED: float = 0.05
const CAMERA_ZOOM_MIN: float = 2.0
const CAMERA_ZOOM_MAX: float = 9.0
const CAMERA_MOVEMENT_LAG: float = 0.5
const CAMERA_MOVEMENT_SPEED: float = 15.0
const CAMERA_ROTATION_SPEED: float = 2.0

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


func handle_desired_camera_movement(event: InputEvent) -> void:
    var desired_length: float = CAMERA_MOVEMENT_SPEED * CAMERA_MOVEMENT_LAG
    if event.is_action("camera_forward"):
        desired_camera_movement = Vector3.FORWARD * desired_length
    elif event.is_action("camera_back"):
        desired_camera_movement = Vector3.BACK * desired_length
    elif event.is_action("camera_left"):
        desired_camera_movement = Vector3.LEFT * desired_length
    elif event.is_action("camera_right"):
        desired_camera_movement = Vector3.RIGHT * desired_length
    if event.is_action_released("camera_forward") or event.is_action_released("camera_back") \
        or event.is_action_released("camera_left") or event.is_action_released("camera_right"):
        desired_camera_movement = Vector3.ZERO

func move_camera(delta: float) -> void:
    if desired_camera_movement != Vector3.ZERO:
        var max_movement: Vector3 = desired_camera_movement.normalized() * CAMERA_MOVEMENT_SPEED * delta
        var factor: float = min(desired_camera_movement.length()/max_movement.length(), 1.0)
        if max_movement.length() >= desired_camera_movement.length():
            desired_camera_movement = Vector3.ZERO
        else:
            desired_camera_movement -= max_movement*factor
        var global_movement: Vector3 = to_global(max_movement*factor) - global_position
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
        if Input.is_action_pressed("rotate_camera_left"):
            rotation_change = 1.0
        elif Input.is_action_pressed("rotate_camera_right"):
            rotation_change = -1.0
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
    rotate_camera(delta)
    update_mouse_position_average()
    move_camera(delta)


func _unhandled_input(event: InputEvent) -> void:
    handle_camera_zoom(event)
    handle_desired_camera_movement(event)
