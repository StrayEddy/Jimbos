extends Area2D


export var goLeft = true
export var speed = 40


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
	
	
	var leftCollide = false
	var leftCollider = $LeftRayCast2D.get_collider()
	if leftCollider != null:
		if leftCollider.name != "BigGuy" and leftCollider.name != "SmallGuy":
			leftCollide = true
		
	var rightCollide = false
	var rightCollider = $RightRayCast2D.get_collider()
	if rightCollider != null:
		if rightCollider.name != "BigGuy" and rightCollider.name != "SmallGuy":
			rightCollide = true
	
	var obstacleLeft = goLeft and leftCollide
	var obstacleRight = !goLeft and rightCollide
	var fallLeft = goLeft and $LeftDownRayCast2D.get_collider() == null
	var fallRight = !goLeft and $RightDownRayCast2D.get_collider() == null
	
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
