extends CharacterBody2D

var direction_x := 1.0 
var speed := 5000
var character_type: Constants.Characters
var current_sprite: Texture
@export var gravity := 200
@export var death_speed := 2.5
var acceleration := 1.0
var is_falling: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_character_type(Constants.Characters.BASIC)

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	if !is_obstacle():
		var collision = get_last_slide_collision()
		if collision:
			var collidor = collision.get_collider()
			if (collidor.has_method('is_obstacle') && collidor.is_obstacle()):
				direction_x = direction_x * -1.0
		if is_on_floor():	
			fall_death_check()
			ambulate(delta)
		else:
			fall(delta)
		move_and_slide()
		print(acceleration)
	
func ambulate(delta: float) -> void:
	acceleration = 1.0
	velocity.x = speed * delta * direction_x
	
func fall(_delta: float) -> void:
	print(acceleration)
	acceleration = acceleration * 1.1
	velocity.x = 0
	
func fall_death_check() -> void:
	if acceleration > death_speed:
		queue_free()
	
func apply_gravity(delta: float) -> void:
	velocity.y += gravity * acceleration * delta
	
func is_obstacle() -> bool:
	return character_type == Constants.Characters.STONER
	
func set_character_type(char_type: Constants.Characters):
	character_type = char_type
	# If we're an obstacle, we want to be on the obstacle layer
	set_collision_layer_value(3, is_obstacle())
	$Sprite2D.texture = load(Constants.character_data[character_type]["image"])

# If a character assigner button is clicked when the goblin is clicked, change to that character type
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left click"):
		for button in get_tree().get_nodes_in_group("characterassigners"):
			if button.selected:		
				set_character_type(button.character_type)

# If the goblin leaves the screen, he dead
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
