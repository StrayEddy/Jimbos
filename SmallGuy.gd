extends KinematicBody2D

export (int) var speed = 200
export (int) var dash_speed = 1000
export (int) var jump_speed = -250
export (int) var gravity = 500
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.15

var velocity = Vector2.ZERO

var dashItemScene = load("res://DashItem.tscn")
var bigGuy
var play

func _ready():
	bigGuy = get_tree().get_nodes_in_group("BigGuy")[0]
	play = get_tree().get_nodes_in_group("Play")[0]

func get_input():
	var dir = 0
	if Input.is_action_pressed("p1_ui_right"):
		$AnimatedSprite.flip_h = false
		dir += 1
	if Input.is_action_pressed("p1_ui_left"):
		$AnimatedSprite.flip_h = true
		dir -= 1
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
		walk()
	else:
		idle()
		velocity.x = lerp(velocity.x, 0, friction)
	
func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	check_collisions()
	
	if is_on_floor() and Input.is_action_just_pressed("p1_ui_a"):
			jump()
	if Input.is_action_just_pressed("p1_ui_b") and $DashTimer.is_stopped():
			dash()
	if Input.is_action_just_pressed("p1_ui_x") and $DashItemTimer.is_stopped():
			dash_item()

func check_collisions():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "BigGuy":
			$AnimatedSprite.play("jump")
			velocity.y = jump_speed * 2
			bigGuy.stand_up()

func idle():
	$AnimatedSprite.play("idle")

func walk():
	$AnimatedSprite.play("walk")

func jump():
	$AnimatedSprite.play("jump")
	velocity.y = jump_speed

func fall():
	$AnimatedSprite.play("fall")

func dash():
	$AnimatedSprite.play("dash")
	$DashTimer.start()
	if $AnimatedSprite.flip_h:
		velocity.x = -dash_speed
	else:
		velocity.x = dash_speed

func dash_item():
	$DashItemTimer.start()
	var dashItem = dashItemScene.instance()
	if $AnimatedSprite.flip_h:
		dashItem.position = position - Vector2(50,0)
	else:
		dashItem.position = position + Vector2(50,0)
	play.add_child(dashItem)
