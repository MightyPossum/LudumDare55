extends CharacterBody3D

@onready var camera: Camera3D = $Camera

const SPEED = 5.0
const ACCELERATION = 100.0

var jump_height: float = 1 
var camera_sensitivity: float = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var jumping: bool = false
var mouse_captured: bool = false

var move_direction: Vector2 # Input direction for movement
var look_direction: Vector2 # Input direction for look/aim

var move_velocity: Vector3 # Walking velocity 
var grav_velocity: Vector3 # Gravity velocity 
var jump_velocity: Vector3 # Jumping velocity

func _ready() -> void:
	capture_mouse()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_direction = event.relative * 0.001
		if mouse_captured: _rotate_camera()
	if Input.is_action_just_pressed("Jump"): jumping = true
	if Input.is_action_just_pressed("Exit"): get_tree().quit()

func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func _rotate_camera(sens_modifier: float = 1.0) -> void:
	camera.rotation.y -= look_direction.x * camera_sensitivity * sens_modifier
	camera.rotation.x = clamp(camera.rotation.x - look_direction.y * camera_sensitivity * sens_modifier, -1.5, 1.5)

func _movment(delta: float) -> Vector3:
	move_direction = Input.get_vector("Move_Left", "Move_Right", "Move_Up", "Move_Down")
	var _forward: Vector3 = camera.global_transform.basis * Vector3(move_direction.x, 0, move_direction.y)
	var walk_direction: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	move_velocity = move_velocity.move_toward(walk_direction * SPEED * walk_direction.length(), ACCELERATION * delta)
	return move_velocity

func _gravity(delta: float) -> Vector3:
	grav_velocity = Vector3.ZERO if is_on_floor() else grav_velocity.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	return grav_velocity

func _jump(delta: float) -> Vector3:
	if jumping:
		if is_on_floor(): jump_velocity = Vector3(0, sqrt(4 * jump_height * gravity), 0)
		jumping = false
		return jump_velocity
	jump_velocity = Vector3.ZERO if is_on_floor() else jump_velocity.move_toward(Vector3.ZERO, gravity * delta)
	return jump_velocity


func _physics_process(delta):
	velocity = _movment(delta) + _gravity(delta) + _jump(delta)
	move_and_slide()