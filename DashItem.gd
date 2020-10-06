extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_DashItem_body_entered(body):
	match body.name:
		"BigGuy", "SmallGuy":
			body.dash()


func _on_Timer_timeout():
	queue_free()
