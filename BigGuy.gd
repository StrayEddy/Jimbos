extends KinematicBody2D

export (int) var speed = 150
export (int) var dash_speed = 1000
export (int) var jump_speed = -300
export (int) var gravity = 500
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.15

var velocity = Vector2.ZERO

var is_lying_down = false
var is_damaged = false
var can_be_damaged = true

var smallGuy
var camera

func _ready():
	smallGuy = get_tree().get_nodes_in_group("SmallGuy")[0]
	camera = get_tree().get_nodes_in_group("Camera")[0]

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
	var snap = Vector2.DOWN * 2 if is_on_floor() else Vector2.ZERO
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP)
	
	check_collisions()
	
	if is_on_floor():
		if Input.is_action_just_pressed("p2_ui_a"):
			jump()
		if Input.is_action_just_pressed("p2_ui_b"):
			lie_down()

func check_collisions():
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision.collider.name == "Spikes":
			if can_be_damaged:
				take_damage()
				camera.shake()

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

func take_damage():
	if is_damaged:
		get_tree().change_scene("res://Play.tscn")
	else:
		$AnimatedSprite.modulate = Color(0,0,0,.5)
		$DamageTimer.start()
		is_damaged = true
		can_be_damaged = false

func _on_DamageTimer_timeout():
	can_be_damaged = true
	$HealTimer.start()

func _on_HealTimer_timeout():
	is_damaged = false
	$AnimatedSprite.modulate = Color(1,1,1,1)
