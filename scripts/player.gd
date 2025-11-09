extends Node3D


var desired_player_position: Vector3 = Vector3.ZERO
const PLAYER_MOVEMENT_SPEED: float = 1.0


func handle_desired_position(event: InputEventMouseButton) -> void:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var hit_position: Vector3 = shoot_ray()
			desired_player_position = hit_position


func move_player(delta: float) -> void:
	var difference: Vector3 = desired_player_position-global_position
	difference.y = position.y
	if difference.length() > 0.1:
		var new_player_position: Vector3 = global_position
		new_player_position += difference.normalized() * delta * PLAYER_MOVEMENT_SPEED
		global_position = new_player_position
		# print("desired position: %, new position: %", [desired_player_position, new_player_position])


func shoot_ray() -> Vector3:
	if RandomNumberGenerator.new().randi() % 2 == 0:
		return Vector3(0, 0, 9.0)
	else:
		return Vector3(0, 0, -9.0)


func _process(_delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	move_player(delta)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		handle_desired_position(event)
