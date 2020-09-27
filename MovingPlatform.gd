extends Node2D

var variableHeight = 100
var originalPos = Vector2()
var goneUp


# Called when the node enters the scene tree for the first time.
func _ready():
	originalPos = position
	$Timer.start(randf()*5)
	$Timer.connect("timeout", self, "go_up")

func go_up():
	$Tween.interpolate_property(self, "position",
		position, originalPos + Vector2(0,-75), 5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	goneUp = true

func go_down():
	$Tween.interpolate_property(self, "position",
		position, originalPos + Vector2(0,75), 5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	goneUp = false

func _on_Tween_tween_all_completed():
	if goneUp:
		go_down()
	else:
		go_up()
