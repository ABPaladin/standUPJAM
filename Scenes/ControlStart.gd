extends Control
func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

var audioStreamPlayer : AudioStreamPlayer2D
func _ready():
	audioStreamPlayer = $"../AudioStreamPlayer2D"  
	audioStreamPlayer.play()
