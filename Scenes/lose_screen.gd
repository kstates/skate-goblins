extends Control

var game_scene: PackedScene = load("res://Scenes/game.tscn")

func _on_button_button_up() -> void:
	get_tree().change_scene_to_packed(game_scene)
