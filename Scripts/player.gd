extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -200.0
const PULL_ACCELERATION = 250
var is_being_pulled = false
var pull_position: Vector2

func _physics_process(delta: float) -> void:
	# Oof ouch hit my head
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var hit = collision.get_normal().dot(collision.get_travel())
		if abs(hit) > .1:
			print("OUCH")
			# die
	
	# Add the gravity.
	if not is_on_floor() and not is_being_pulled:
		velocity += get_gravity() * delta
		print(get_gravity())

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")	

	# Magnetic pull
	if Input.is_action_just_pressed("magnet_pull"):
		if not is_being_pulled:
			var space_state = get_world_2d().direct_space_state
			var camera = get_viewport().get_camera_2d()
			var mouse_coords := camera.get_global_mouse_position()
			var query = PhysicsRayQueryParameters2D.create(global_position, mouse_coords) # multiply this by like 100 so the ray goes "endlessly"?
			query.exclude = [self]
			var result = space_state.intersect_ray(query)
			if result:
				pull_position = result.position
				print(pull_position, mouse_coords)
			is_being_pulled = true
		else:
			is_being_pulled = false
			
	if is_being_pulled:
		# set look_at for arm probs
		velocity += global_position.direction_to(pull_position) * PULL_ACCELERATION * delta

	# Apply left/right movement
	if not is_being_pulled:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
