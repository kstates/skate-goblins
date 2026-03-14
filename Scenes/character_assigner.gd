extends Control

var character_type: Constants.Characters
var tiedye1 = preload("res://Images/TempImages/tiedye.jpg")
var tiedye2 = preload("res://Images/TempImages/tiedye2.jpg")
var moss = preload("res://Images/TempImages/moss.jpg")
var selected: bool

func assign_char_type(char_type: Constants.Characters) -> void:
	character_type = char_type
	$CharType.text = Constants.character_data[character_type]["name"]
	
func set_texture(text) ->void:
	$TextureRect.texture = text

func _on_mouse_entered() -> void:
	if ($TextureRect.texture == tiedye1):
		set_texture(tiedye2)

func _on_texture_rect_mouse_exited() -> void:
	if $TextureRect.texture == tiedye2:
		set_texture(tiedye1)
	
func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left click") && $TextureRect.texture == moss:
		set_texture(tiedye1)
	elif event.is_action_pressed("left click"): 
		for rect in get_tree().get_nodes_in_group("characterassigners"):
			rect.set_texture(tiedye1)
			rect.selected = false
		set_texture(moss)
		selected = true
