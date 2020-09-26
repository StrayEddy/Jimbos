extends Node2D

var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://Menu.tscn")

func win_level():
	pass
