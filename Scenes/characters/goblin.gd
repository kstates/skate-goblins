extends CharacterBody2D

var direction_x := 1.0 
var speed := 5000
var character_type: Characters = Characters.STONER
@export var gravity := 40

enum Characters {BASIC, STONER}
const character_connection = {
	Characters.BASIC: 'basic',
	Characters.STONER: 'stoner'
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: I don't think this is where I want to do this
	if character_type == Characters.STONER:
		set_collision_mask_value(2, true)

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
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
	return character_type == Characters.STONER
