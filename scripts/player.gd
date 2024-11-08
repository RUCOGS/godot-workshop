extends CharacterBody2D
class_name Player


signal died


@export var speed = 300.0
@export var jump_velocity = 400.0
@export var max_jumps = 2
@export var jump_cooldown = 0.5

@export var anim_player: AnimationPlayer
@export var jump_sfx: AudioStreamPlayer
@export var walk_sfx: AudioStreamPlayer
@export var death_sfx: AudioStreamPlayer


var active = true

var is_moving = false
var jump_cooldown_timer = 0
var jumps = 0
var is_slowing_down = false


func _process(delta: float) -> void:
	# walking sfx
	if is_moving and is_on_floor():
		if not walk_sfx.playing:
			walk_sfx.play()
	else:
		if walk_sfx.playing:
			walk_sfx.stop()
	
	# walk animation
	if is_moving:
		if anim_player.current_animation != "walk":
			anim_player.play("walk")
			anim_player.advance(0)
	else:
		if anim_player.current_animation != "idle":
			anim_player.play("idle")
			anim_player.advance(0)
	
	if jump_cooldown_timer > 0:
		jump_cooldown_timer -= delta


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		# Add the gravity
		velocity += get_gravity() * delta
	else:
		# Reset jumps when we hit floor
		jumps = max_jumps

	if active:
	
		# Handle jump.
		if Input.is_action_just_pressed("jump") and jumps > 0 and jump_cooldown_timer <= 0:
			jump()

		# stop jumping early
		if Input.is_action_just_released("jump"):
			velocity.y *= 0.5

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("walk_left", "walk_right")
		if direction:
			velocity.x = direction * speed
			is_moving = true
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			is_moving = false
	else:
		is_moving = false
		velocity.x = 0

	move_and_slide()


func jump():
	jump_cooldown_timer = jump_cooldown
	jumps -= 1
	jump_sfx.play()
	velocity.y = -jump_velocity


func kill():
	death_sfx.play()
	died.emit()
