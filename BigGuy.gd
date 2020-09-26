extends KinematicBody2D

export (int) var speed = 150
export (int) var dash_speed = 1000
export (int) var jump_speed = -300
export (int) var gravity = 500
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.15

var velocity = Vector2.ZERO

var is_lying_down = false

var smallGuy

func _ready():
	smallGuy = get_tree().get_nodes_in_group("SmallGuy")[0]

func get_movement_input():
	var dir = 0
	if Input.is_action_pressed("p2_ui_right"):
		$AnimatedSprite.flip_h = false
		dir += 1
	if Input.is_action_pressed("p2_ui_left"):
		$AnimatedSprite.flip_h = true
		dir -= 1
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
		walk()
	else:
		idle()
		velocity.x = lerp(velocity.x, 0, friction)
	
func _physics_process(delta):
	if is_lying_down:
		if Input.is_action_just_pressed("p2_ui_b"):
			stand_up()
		return
	
	get_movement_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if is_on_floor():
		if Input.is_action_just_pressed("p2_ui_a"):
			jump()
		if Input.is_action_just_pressed("p2_ui_b"):
			lie_down()

func idle():
	$AnimatedSprite.play("idle")

func walk():
	$AnimatedSprite.play("walk")

func jump():
	$AnimatedSprite.play("jump")
	velocity.y = jump_speed

func fall():
	$AnimatedSprite.play("fall")

func lie_down():
	$AnimatedSprite.play("lie_down")
	collision_layer = 1
	collision_mask = 1
	is_lying_down = true

func down_idle():
	$AnimatedSprite.play("down_idle")

func bounce():
	$AnimatedSprite.play("bounce")

func stand_up():
	$AnimatedSprite.play("stand_up")
	collision_layer = 2
	collision_mask = 2
	is_lying_down = false

func dash():
	if $AnimatedSprite.flip_h:
		velocity.x = -dash_speed
	else:
		velocity.x = dash_speed


func _on_AnimatedSprite_animation_finished():
	match $AnimatedSprite.animation:
		"lie_down":
			down_idle()
