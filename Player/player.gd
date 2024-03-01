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
var was_in_air : bool = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air = true
	else:
		#double jump resets when on ground
		double_jump_usable = true
		
		if was_in_air == true:
			land()
		
		was_in_air = false

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			jump()
		
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
	update_facing_direction()
	
func update_animation(): 
	if not animation_locked: 
		if not is_on_floor:
			animated_sprite.play("Air")
			#animation_locked = true
		else:
			if direction.x != 0:
				animated_sprite.play("Run")
			else:
				animated_sprite.play("Idle")
			
func update_facing_direction():
	if direction.x > 0:
		animated_sprite.flip_h = true 
	elif direction.x < 0:
		animated_sprite.flip_h = false

func jump():
	#normal jump from floor
	velocity.y = jump_velocity
	animated_sprite.play("Jump")
	animation_locked = true
	
func land():
	animated_sprite.play("Land")
	animation_locked = true
	print(animated_sprite.animation )


func _on_animated_sprite_2d_animation_finished():
	print("animation finished")
	if(animated_sprite.animation == "Land"):
		print("yes")
		animation_locked = false
	#elif(animated_sprite.animation == "Jump"):
		#animation_locked = false
	elif(animated_sprite.animation == "Jump"):
		animated_sprite.play("Air")
		animation_locked = true


#func _on_animated_sprite_2d_animation_looped():
	#print("animation finished")
	#if(animated_sprite.animation == "Land"):
		#print("yes")
		#animation_locked = false
