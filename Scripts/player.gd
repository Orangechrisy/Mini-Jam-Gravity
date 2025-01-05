extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -200.0
const PULL_ACCELERATION = 700
const GRAVITY := Vector2(0, 600)
const acc : float = 20
var is_being_pulled = false
var pull_position: Vector2
var prev_velocity: Vector2

@onready var player: CharacterBody2D = $"."
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hair_timer: Timer = $"hair timer"
@onready var death_reset_timer: Timer = $"death reset timer"

func _ready():
	hair_timer.start()

func _physics_process(delta: float) -> void:
	
	# change hair color? not sure where this would go tbh
	
	
	# Add the gravity.
	if not is_on_floor() and not is_being_pulled:
		velocity += GRAVITY * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		#print("jump vel: " + str(velocity.y))
		velocity.y = JUMP_VELOCITY
		#print("jump vel 2: " + str(velocity.y))

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")	

	# Magnetic pull
	if Input.is_action_just_pressed("magnet_pull"):
		if not is_being_pulled:
			var space_state = get_world_2d().direct_space_state
			var camera = get_viewport().get_camera_2d()
			var mouse_coords = camera.get_global_mouse_position()
			var static_vector = global_position + global_position.direction_to(mouse_coords) * 300
			var query = PhysicsRayQueryParameters2D.create(global_position, static_vector)
			query.exclude = [self]
			var result = space_state.intersect_ray(query)
			if result:
				pull_position = result.position
				is_being_pulled = true
		else:
			is_being_pulled = false
			
	if is_being_pulled:
		# set look_at for arm probs
		#print("pull vel: " + str(velocity))
		velocity += global_position.direction_to(pull_position) * PULL_ACCELERATION * delta
		#print("pull vel 2: " + str(velocity))

	# flipping
	if velocity.x > 0:
		player.scale.x = 1
		#animation_player.flip_h = false
	elif velocity.x < 0:
		player.scale.x = -1
		#animation_player.flip_h = true

	# animes
	if is_on_floor():
		if direction == 0:
			animation_player.play("idle")
		else:
			animation_player.play("run")
	else:
		animation_player.play("jump")

	# left/right movement
	if not is_being_pulled and is_on_floor():
		if direction:
			velocity.x = move_toward(velocity.x, direction * SPEED, acc)
		else:
			velocity.x = move_toward(velocity.x, 0, acc)

	# big change in velocity = death
	var vel_diff: Vector2 = prev_velocity - velocity
	#print(str(prev_velocity.length()) + ", " + str(velocity.length()) + ", " + str(vel_diff.length()))
	if vel_diff.length() > 250:
		print("Ouch")
		is_being_pulled = false
		animation_player.play("die")
		Engine.time_scale = .25
		death_reset_timer.start()
		#for i in get_slide_collision_count():
			#var collision = get_slide_collision(i)
			#print("collider vel: " + str(collision.get_remainder()))
			#velocity = prev_velocity.bounce(collision.get_normal())
		
	prev_velocity = velocity
	set_floor_snap_length(0.0)
	#var collision = move_and_collide(velocity * delta)
	#if collision:
	#	velocity = velocity.slide(collision.get_normal())
	move_and_slide()

func _on_hair_timer_timeout() -> void:
	print("Ouch")
	is_being_pulled = false
	animation_player.play("die")
	Engine.time_scale = .25
	death_reset_timer.start()

func _on_death_reset_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
