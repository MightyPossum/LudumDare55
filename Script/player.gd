extends CharacterBody3D

@onready var camera: Camera3D = $Camera
@onready var staffCam : Camera3D = %StaffCam
@onready var anim_player : AnimationPlayer = $AnimationPlayer
@export var projectileModel : PackedScene
var timer = 0


var speed
const SPRINT = 20.0
const WALK_SPEED = 10.0
const ACCELERATION = 100.0

var jump_height: float = 4.5
var camera_sensitivity: float = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var jumping: bool = false
var mouse_captured: bool = false

var move_direction: Vector2
var look_direction: Vector2

var grav_velocity: Vector3  
var move_velocity: Vector3  
var jump_velocity: Vector3 

func _ready() -> void:
	anim_player.play("idle")
	capture_mouse()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_direction = event.relative * 0.001
		if mouse_captured: _rotate_camera()
	if Input.is_action_just_pressed("Jump"): 
		jumping = true
		if is_on_floor:
			$jumpPlayer.play()
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				anim_player.play("Attack")				
				if anim_player.animation_finished:
					var projectile = projectileModel.instantiate()
					get_parent().add_child(projectile)
					projectile.global_position = %projectileSpawn.global_position
					projectile.rotation = camera.rotation
					
				
				#spawn object

func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false
	
func _rotate_camera(sens_modifier: float = 1.0) -> void:
	camera.rotation.y -= look_direction.x * camera_sensitivity * sens_modifier
	camera.rotation.x = clamp(camera.rotation.x - look_direction.y * camera_sensitivity * sens_modifier, -1.5, 1.5)

func _movment(delta: float) -> Vector3:
	move_direction = Input.get_vector("Move_Left", "Move_Right", "Move_Up", "Move_Down")
	var _forward: Vector3 = camera.global_transform.basis * Vector3(move_direction.x, 0, move_direction.y)
	var walk_direction: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	
	if Input.is_action_pressed("Sprint"):
		speed = SPRINT
	else:
		speed = WALK_SPEED
		
		timer = 0
	move_velocity = move_velocity.move_toward(walk_direction * speed * walk_direction.length(), ACCELERATION * delta)
	
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
	
func _process(_delta: float) -> void:
	timer += _delta
	staffCam.global_position = camera.global_position
	staffCam.rotation = camera.rotation

func _physics_process(delta):
	velocity = _movment(delta) + _gravity(delta) + _jump(delta)
	move_and_slide()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Attack":
		anim_player.play("idle")
	pass # Replace with function body.
