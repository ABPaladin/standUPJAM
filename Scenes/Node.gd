extends Node


var sprite2d : Sprite2D

func _ready():
	sprite2d = get_node("../Sprite2D")
	disable_sprite()

func disable_sprite():
	# Disable the Sprite2D node
	sprite2d.visible = false
