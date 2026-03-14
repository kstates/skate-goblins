extends CharacterBody2D

var direction_x := 1.0 
var speed := 5000
var character_type: Constants.Characters
var current_sprite: Texture
@export var gravity := 40

# Character Images
var basic_goblin_sprite = preload("res://Images/TempImages/aseprite/basic-goblin-one.png")
var stoner_goblin_sprite = preload("res://Images/TempImages/aseprite/stoner-gobline-one.png")

var character_types_dict = {
	Constants.Characters.BASIC: {
		"image": basic_goblin_sprite,
	},
	Constants.Characters.STONER: {
		"image": stoner_goblin_sprite
	}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_character_type(Constants.Characters.BASIC)

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	if !is_obstacle():
		ambulate(delta)
		var collision = move_and_collide(velocity * delta)
		if collision:
			var collidor = collision.get_collider()
			if (collidor.has_method('is_obstacle') && collidor.is_obstacle()):
				direction_x = direction_x * -1.0
			else: 
				velocity = velocity.slide(collision.get_normal())
	
func ambulate(delta: float) -> void:
	velocity.x = speed * delta * direction_x
	
func apply_gravity(delta: float) -> void:
	velocity.y += gravity * delta
	
func is_obstacle() -> bool:
	return character_type == Constants.Characters.STONER
	
func set_character_type(char_type: Constants.Characters):
	character_type = char_type
	set_collision_layer_value(3, is_obstacle())
	
	$Sprite2D.texture = character_types_dict[character_type].image

			
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left click"):
		for button in get_tree().get_nodes_in_group("characterassigners"):
			if button.selected:		
				set_character_type(button.character_type)
