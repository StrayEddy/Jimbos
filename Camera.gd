extends Camera2D

var bigGuy
var camera_pos_before

# Called when the node enters the scene tree for the first time.
func _ready():
	bigGuy = get_tree().get_nodes_in_group("BigGuy")[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera_pos_before = position
	$Tween.interpolate_property(self, "position",
		position, bigGuy.position, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
