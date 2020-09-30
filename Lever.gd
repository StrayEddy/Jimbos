extends Area2D

var camera

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_tree().get_nodes_in_group("Camera")[0]

func _on_Lever_body_entered(body):
	match body.name:
		"BigGuy", "SmallGuy":
			activate()

func activate():
	$AnimatedSprite.play("activate")
	camera.big_shake()
