extends KinematicBody2D

export (int) var speed = 400
export (int) var dash_speed = 2000
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

var velocity = Vector2.ZERO
var play
var camera
var old_camera_pos

var animal = "dog"
var animals = ["cat", "cow", "crocodile", "dog", "duck", "elephant", "fox", "horse", "monkey", "panda", "penguin", "pig", "rabbit", "sheep", "snake"]

# Called when the node enters the scene tree for the first time.
func _ready():
	play = get_tree().get_nodes_in_group("Play")[0]
	camera = get_tree().get_nodes_in_group("Camera")[0]
	$Light2D.color = Color.white
	old_camera_pos = camera.position

func _process(delta):
	if not $ShakeTimer.is_stopped():
		move_local_x(rand_range(-5.0, 5.0))
		move_local_y(rand_range(-5.0, 5.0))

func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity, Vector2.UP)
	var delta_camera = camera.position - old_camera_pos
	old_camera_pos = camera.position
	position += delta_camera
	
	var x_limit = OS.window_size.x/2
	var y_limit = OS.window_size.y/2
	if position.x < camera.position.x - x_limit + 75:
		position.x = camera.position.x - x_limit + 75
	elif position.x > camera.position.x + x_limit - 75:
		position.x = camera.position.x + x_limit - 75
	
	if position.y < camera.position.y - y_limit + 75:
		position.y = camera.position.y - y_limit + 75
	elif position.y > camera.position.y + y_limit - 75:
		position.y = camera.position.y + y_limit - 75

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
		$CPUParticles2D.emitting = true
		velocity = lerp(velocity, dir * speed, acceleration)
	else:
		$CPUParticles2D.emitting = false
		velocity = lerp(velocity, Vector2.ZERO, friction)

func _input(event):
	if event.is_action_pressed("p3_ui_a"):
		$Light2D.color = Color.green
		talk()
	if event.is_action_pressed("p3_ui_x"):
		$Light2D.color = Color.blue
		talk()
	if event.is_action_pressed("p3_ui_b"):
		$Light2D.color = Color.red
		change_animal()
	if event.is_action_pressed("p3_ui_y"):
		$Light2D.color = Color.white
		change_animal()

func dash():
	if $AnimatedSprite.flip_h:
		velocity.x = -dash_speed
	else:
		velocity.x = dash_speed

func change_animal():
	var next_index = (animals.find(animal) + 1) % animals.size()
	animal = animals[next_index]
	$AnimatedSprite.play(animal)
	talk()

func talk():
	get_node(animal).play()
	$ShakeTimer.start()

func _on_TalkTimer_timeout():
	talk()
	$TalkTimer.start(15 + randi() % 15)
