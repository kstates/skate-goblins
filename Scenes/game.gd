extends Node2D

const character_assigner_scene = preload("res://Scenes/character_assigner.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button in $UI/HFlowContainer.get_children():
		button.queue_free()
		
	for char_type in Constants.Characters:
		var character_assigner = character_assigner_scene.instantiate()
		character_assigner.assign_char_type(Constants.Characters[char_type])
		$UI/HFlowContainer.add_child(character_assigner)
