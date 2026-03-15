extends CharacterBody2D

var direction_x := 1.0 
var speed := 5000
var character_type: Constants.Characters
var current_sprite: Texture
var splat_sprite = preload("res://Images/TempImages/aseprite/splat.png")
var explode_sprite = preload("res://Images/TempImages/aseprite/munitions-goblin-exploded.png")
@export var gravity := 200
@export var death_speed := 35
var acceleration := 1.0
var is_falling: bool = false
var is_dead: bool = false
var lose_scene: PackedScene = preload("res://Scenes/lose_screen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_character_type(Constants.Characters.BASIC)

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	match character_type:
		Constants.Characters.DIG:
			dig()
		_:
			if !is_obstacle() and !is_dead:
				var collision = get_last_slide_collision()
				if collision:
					var collider = collision.get_collider()
					if collider.has_method('is_obstacle') && collider.is_obstacle():
						if character_type == Constants.Characters.MUNITIONS:
							explode(collider)
						else:
							change_direction()
				if is_on_floor():	
					fall_death_check()
					ambulate(delta)
				else:
					fall(delta)
				move_and_slide()
		
func explode(collider) -> void:
	is_dead = true
	await get_tree().create_timer(1).timeout
	$Sprite2D.texture = explode_sprite
	await get_tree().create_timer(1).timeout
	collider.explode()
	death()
	
func ambulate(delta: float) -> void:
	acceleration = 1.0
	velocity.x = speed * delta * direction_x
	
func fall(_delta: float) -> void:
	acceleration = acceleration * 1.1
	velocity.x = 0
	
func fall_death_check() -> void:
	if acceleration > death_speed:
		is_dead = true
		$Sprite2D.texture = splat_sprite
		await get_tree().create_timer(1).timeout
		death()
		
func change_direction() -> void:
	direction_x = direction_x * -1.0
	
func apply_gravity(delta: float) -> void:
	velocity.y += gravity * acceleration * delta
	
func is_obstacle() -> bool:
	return character_type == Constants.Characters.STONER
	
func dig() -> void:
	var collision = get_last_slide_collision()
	if collision:
		var collider = collision.get_collider()
		if collider is TileMapLayer:
			var tile_coords = collider.local_to_map(position)
			tile_coords.y = tile_coords.y + 2
			collider.erase_cell(tile_coords)
	move_and_slide()
	
func set_character_type(char_type: Constants.Characters):
	if not is_dead:
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
	death()
	
func death() -> void:
	var goblins = get_tree().get_nodes_in_group("goblins")
	if goblins.size() == 1:
		get_tree().change_scene_to_packed(lose_scene)
	queue_free()
