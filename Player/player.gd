extends CharacterBody2D


@export var speed : float = 300.0
@export var jump_velocity : float = -400.0
@export var double_jump_velocity : float = -200.0

var double_jump_usable : bool = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		double_jump_usable = true

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			#normal jump from floor
			velocity.y = jump_velocity
		
		elif double_jump_usable:
			#double jump in air
			velocity.y = double_jump_velocity
			double_jump_usable = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
