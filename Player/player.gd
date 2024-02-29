extends CharacterBody2D


@export var speed : float = 300.0
@export var jump_velocity : float = -400.0
@export var double_jump_velocity : float = -200.0

@onready var animated_sprite :AnimatedSprite2D = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var double_jump_usable : bool = true
var animation_locked : bool = false
var direction : Vector2 = Vector2.ZERO

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		#double jump resets when on ground
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
	direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	update_animation()
	
func update_animation() -> void: 
	if not animation_locked: 
		if direction.x != 0:
			animated_sprite.play("Run")
		else:
			animated_sprite.play("Idle")
		
