extends StaticBody2D

export var waitTime = 3.0
export var isActive = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = waitTime
	if isActive:
		$CollisionShape2D.disabled = false
		show()
	else:
		$CollisionShape2D.disabled = true
		hide()

func _on_Timer_timeout():
	if isActive:
		$CollisionShape2D.disabled = true
		hide()
	else:
		$CollisionShape2D.disabled = false
		show()
	isActive = !isActive
