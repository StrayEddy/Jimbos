extends Node2D

export var speed = 30
export var offset = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Path2D/PathFollow2D.unit_offset = offset


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Path2D/PathFollow2D.offset += speed*delta
