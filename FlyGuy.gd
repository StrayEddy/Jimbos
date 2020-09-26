extends KinematicBody2D

export (int) var speed = 300
export (int) var dash_speed = 2000
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

var velocity = Vector2.ZERO
var play
var camera

var old_camera_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	play = get_tree().get_nodes_in_group("Play")[0]
	camera = get_tree().get_nodes_in_group("Camera")[0]
	$Light2D.color = Color.lightyellow
	old_camera_pos = camera.position
	
	
func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity, Vector2.UP)
	var delta_camera = camera.position - old_camera_pos
	old_camera_pos = camera.position
	position += delta_camera
	
	if position.x < camera.position.x:
		position.x = camera.position.x
	elif position.x > camera.position.x + OS.window_size.x:
		position.x = camera.position.x + OS.window_size.x
	
	if position.y < camera.position.y:
		position.y = camera.position.y
	elif position.y > OS.window_size.y:
		position.y = OS.window_size.y

func get_input():
	var dir = Vector2.ZERO
	if Input.is_action_pressed("p3_ui_right"):
		$AnimatedSprite.flip_h = false
		dir.x += 1
	if Input.is_action_pressed("p3_ui_left"):
		$AnimatedSprite.flip_h = true
		dir.x -= 1
	if Input.is_action_pressed("p3_ui_down"):
		dir.y +=1
	if Input.is_action_pressed("p3_ui_up"):
		dir.y -= 1
	if dir != Vector2.ZERO:
		velocity = lerp(velocity, dir * speed, acceleration)
		move()
	else:
		idle()
		velocity = lerp(velocity, Vector2.ZERO, friction)

func _input(event):
	if event.is_action_pressed("p3_ui_a"):
		$Light2D.color = Color.lightgreen
		special_move()
	if event.is_action_pressed("p3_ui_b"):
		$Light2D.color = Color.lightpink
		special_move()
	if event.is_action_pressed("p3_ui_x"):
		$Light2D.color = Color.lightblue
		special_move()
	if event.is_action_pressed("p3_ui_y"):
		$Light2D.color = Color.lightyellow
		special_move()

func idle():
	$AnimatedSprite.play("idle")

func move():
	$AnimatedSprite.play("move")

func special_move():
	$AnimatedSprite.play("special_move")

func dash():
	if $AnimatedSprite.flip_h:
		velocity.x = -dash_speed
	else:
		velocity.x = dash_speed
