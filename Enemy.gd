extends Area2D


var goLeft = true
var speed = 20 + randi() % 30


# Called when the node enters the scene tree for the first time.
func _ready():
	goLeft = true
	$AnimatedSprite.flip_h = true
	
	if randi() % 2:
		goLeft = false
		$AnimatedSprite.flip_h = false

func _process(delta):
	if goLeft:
		position.x -= speed*delta
	else:
		position.x += speed*delta
	
	var obstacleLeft = goLeft and $LeftRayCast2D.get_collider() != null
	var obstacleRight = !goLeft and $RightRayCast2D.get_collider() != null
	var fallLeft = goLeft and $LeftDownRayCast2D.get_collider() == null
	var fallRight = !goLeft and $RightDownRayCast2D.get_collider() == null
	
	print("obstacleLeft: " + String(obstacleLeft))
	print("obstacleRight: "+ String(obstacleRight))
	print("fallLeft: "+ String(fallLeft))
	print("fallRight: "+String(fallRight))
	if obstacleLeft or obstacleRight or fallLeft or fallRight:
		turn()

func turn():
	if goLeft:
		$AnimatedSprite.flip_h = false
		goLeft = false
	else:
		$AnimatedSprite.flip_h = true
		goLeft = true
		

func _on_Enemy_body_entered(body):
	match body.name:
		"BigGuy", "SmallGuy":
			body.take_damage()
