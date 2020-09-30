extends StaticBody2D

var lever

# Called when the node enters the scene tree for the first time.
func _ready():
	lever = get_tree().get_nodes_in_group("Lever")[0]
	lever.connect("activate", self, "unlock")
	modulate = Color(1,1,1,0.3)

func unlock():
	modulate = Color(1,1,1,1)
	collision_layer = 3
	collision_mask = 3
