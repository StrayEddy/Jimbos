extends KinematicBody2D

export (int) var speed = 200
export (int) var dash_speed = 1000
export (int) var jump_speed = -250
export (int) var gravity = 500
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.15

var velocity = Vector2.ZERO
var is_damaged = false
var can_be_damaged = true

var dashItemScene = load("res://DashItem.tscn")
var bigGuy
var play
var camera

func _ready():
	bigGuy = get_tree().get_nodes_in_group("BigGuy")[0]
	play = get_tree().get_nodes_in_group("Play")[0]
	camera = get_tree().get_nodes_in_group("Camera")[0]

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
	var snap = Vector2.DOWN * 2 if is_on_floor() else Vector2.ZERO
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP)
	
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
		elif collision.collider.name == "Spikes":
			if can_be_damaged:
				take_damage()

func idle():
	$AnimatedSprite.play("idle")

func walk():
	$AnimatedSprite.play("walk")

func jump():
	$AnimatedSprite.play("jump")
	velocity.y = jump_speed
	$AudioJump.play(0.05)

func fall():
	$AnimatedSprite.play("fall")

func dash():
	$AnimatedSprite.play("dash")
	$AudioDash.play()
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

func take_damage():
	if is_damaged:
		get_tree().change_scene("res://Play.tscn")
	else:
		$AnimatedSprite.modulate = Color(0,0,0,.5)
		$DamageTimer.start()
		is_damaged = true
		can_be_damaged = false
		camera.shake()

func _on_DamageTimer_timeout():
	can_be_damaged = true
	$HealTimer.start()

func _on_HealTimer_timeout():
	is_damaged = false
	$AnimatedSprite.modulate = Color(1,1,1,1)
