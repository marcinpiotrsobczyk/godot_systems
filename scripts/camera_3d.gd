extends Camera3D

@export var rotation_helper: Node3D
@export var player: Node3D

const CAMERA_ZOOM_SPEED: float = 0.1
const CAMERA_ZOOM_MIN: float = 2.0
const CAMERA_ZOOM_MAX: float = 9.0
const CAMERA_ROTATION_SPEED: float = 0.01

func get_camera_position_y(z: float) -> float:
	return z/2.0 + z*z / 10.0

func get_camera_rotation_x(z: float) -> float:
	return -30.0 - z * 5.0


func _ready() -> void:
	position.y = get_camera_position_y(position.z)
	rotation_degrees.x = get_camera_rotation_x(position.z)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var position_difference: Vector3 = global_position - player.global_position
		position_difference.y = 0.0
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if position_difference.length() < CAMERA_ZOOM_MAX:
				position.z += position_difference.length() *  CAMERA_ZOOM_SPEED
				position.y = get_camera_position_y(position.z)
				rotation_degrees.x = get_camera_rotation_x(position.z)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if position_difference.length() > CAMERA_ZOOM_MIN:
				position.z -= position_difference.length() *  CAMERA_ZOOM_SPEED
				position.y = get_camera_position_y(position.z)
				rotation_degrees.x = get_camera_rotation_x(position.z)
	elif event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
			var movement_horizontal = event.screen_relative.x * CAMERA_ROTATION_SPEED
			rotation_helper.rotate(Vector3.UP, movement_horizontal)
