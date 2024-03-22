extends CharacterBody2D
var gravity : Vector2
@export var jump_height : float ## How high should they jump?
@export var movement_speed : float ## How fast can they move?
@export var horizontal_air_coefficient : float ## Should the player move more slowly left and right in the air? Set to zero for no movement, 1 for the same
@export var speed_limit : float ## What is the player's max speed? 
@export var friction : float ## What friction should they experience on the ground?

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity = Vector2(0, 50)
	pass # Replace with function body.


func _get_input():
	if is_on_floor():
		if Input.is_action_pressed("move_left"):
			velocity += Vector2(-movement_speed,0)
# if godobot is on the ground he will move left when the move left button is pressed 
		if Input.is_action_pressed("move_right"):
			velocity += Vector2(movement_speed,0)
# if godotbot is on the ground he will move right when the move right button is pressed
		if Input.is_action_just_pressed("jump"): # Jump only happens when we're on the floor (unless we want a double jump, but we won't use that here)
			velocity += Vector2(1,-jump_height)
# if godot bot is on the ground he will jump whenever the button for jump is pressed
	if not is_on_floor():
		if Input.is_action_pressed("move_left"):
			velocity += Vector2(-movement_speed * horizontal_air_coefficient,0)
#when godot bot is in the air he can still move to the left if the move left button is pressed
		if Input.is_action_pressed("move_right"):
			velocity += Vector2(movement_speed * horizontal_air_coefficient,0)
#when godot bot is still in the air he can still move to the right if the button set for moving right is pressed
func _limit_speed():
	if velocity.x > speed_limit:
		velocity = Vector2(speed_limit, velocity.y)
#left/right velocity is greater than the speed limit it will bring the velocity back down to the speed limit when moving to the right 
	if velocity.x < -speed_limit:
		velocity = Vector2(-speed_limit, velocity.y)

func _apply_friction():
	if is_on_floor() and not (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		velocity -= Vector2(velocity.x * friction, 0)
		if abs(velocity.x) < 5:
			velocity = Vector2(0, velocity.y) # if the velocity in x gets close enough to zero, we set it to zero
#godot bot slows down???
func _apply_gravity():
	if not is_on_floor():
		velocity += gravity
#gravity is applied if Godot bot is in the air so that he can come back down 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_get_input()
	_limit_speed()
	_apply_friction()
	_apply_gravity()

	move_and_slide()
	pass
