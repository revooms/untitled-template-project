extends CharacterBody3D

@export var speed: float = 5.5
@export var speed_sprint: float = 8.2
@export var jump_velocity: float = 6.5
@export var mouse_sensitivity = 0.002

var last_position: Vector3
var distance_travelled: float = 0.0
var distance_travelled_on_floor: float = 0.0
var distance_travelled_in_air: float = 0.0
var times_jumped: int = 0
var first_start_date: String

@onready var camera_3d: Camera3D = $CameraPivot/CameraArm/Camera3D

func _ready():
	last_position = global_position
	if first_start_date == null or first_start_date == "":
		first_start_date = Time.get_datetime_string_from_system()
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()

	var current_position = global_position
	var distance_this_frame = last_position.distance_to(current_position)
	distance_travelled += distance_this_frame
	if is_on_floor():
		distance_travelled_on_floor += distance_this_frame
	else:
		distance_travelled_in_air += distance_this_frame
		
	last_position = current_position
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera_3d.rotate_x(-event.relative.y * mouse_sensitivity)
		camera_3d.rotation.x = clampf(camera_3d.rotation.x, -deg_to_rad(70), deg_to_rad(70))

func jump() -> void:
	times_jumped += 1
	velocity.y = jump_velocity

func get_persistant_object() -> Dictionary:
	return {
		"position": self.position,
		"rotation": self.rotation,
		"distance_travelled": self.distance_travelled, 
		"distance_travelled_on_floor": self.distance_travelled_on_floor, 
		"distance_travelled_in_air": self.distance_travelled_in_air, 
		"times_jumped": self.times_jumped, 
		"first_start_date": self.first_start_date,
	}
