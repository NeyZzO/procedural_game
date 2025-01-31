extends CharacterBody2D
class_name Player;

var speed := 130.0
const JUMP_VELOCITY := -300.0

enum PLAYER_MODE {
	PHYSICS,
	NOCLIP
};

var pMode: PLAYER_MODE = PLAYER_MODE.PHYSICS;

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and pMode == PLAYER_MODE.PHYSICS:
		velocity += get_gravity() * delta

	if Input.is_action_pressed("sprint"):
		speed = 260;
	else:
		speed = 130.0;

	# Handle noclip
	if Input.is_action_just_released("switch_mode"):
		if pMode == PLAYER_MODE.PHYSICS:
			pMode = PLAYER_MODE.NOCLIP;
		else:
			pMode = PLAYER_MODE.PHYSICS;
		print('Switched gamemode');

	if pMode == PLAYER_MODE.NOCLIP:
		if Input.is_action_pressed("up"):
			velocity.y = -speed;
		elif Input.is_action_pressed("down"):
			velocity.y = speed;
		else:
			velocity.y = 0;
	
	$CollisionShape2D.disabled = pMode == PLAYER_MODE.NOCLIP;
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
