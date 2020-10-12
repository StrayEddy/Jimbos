extends Camera2D

var bigGuy
var camera_pos_before
var shake_intensity = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	bigGuy = get_tree().get_nodes_in_group("BigGuy")[0]
	position = bigGuy.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera_pos_before = position
	$Tween.interpolate_property(self, "position",
		position, bigGuy.position, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
	if not $ShakeTimer.is_stopped():
		set_offset(Vector2(rand_range(-5.0, 5.0), rand_range(-5.0, 5.0)))
	elif $AudioRumbling.playing:
		$AudioRumbling.stop()

func shake():
	shake_intensity = 5.0
	$ShakeTimer.start(.5)
	$AudioRumbling.play()

func big_shake():
	shake_intensity = 2.0
	$ShakeTimer.start(2)
	$AudioRumbling.play()
