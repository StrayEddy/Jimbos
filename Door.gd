extends Area2D

var smallGuyEntered = false
var bigGuyEntered = false

func _on_Door_body_entered(body):
	match body.name:
		"BigGuy":
			bigGuyEntered = true
		"SmallGuy":
			smallGuyEntered = true
	
	if smallGuyEntered and bigGuyEntered:
		get_tree().change_scene("res://Menu.tscn")

func _on_Door_body_exited(body):
	match body.name:
		"BigGuy":
			bigGuyEntered = false
		"SmallGuy":
			smallGuyEntered = false
