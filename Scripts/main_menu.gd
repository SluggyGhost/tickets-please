extends Control


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/node_2d.tscn")


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/how_to_play.tscn")
