extends CharacterBody2D

var direction_x := 1.0 
var speed := 5000
@export var gravity := 40

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	ambulate(delta)
	var collision = move_and_collide(velocity * delta)
	if collision:
		if (collision.get_collider().is_in_group("Obstacles")):
			direction_x = direction_x * -1.0
		else: 
			velocity = velocity.slide(collision.get_normal())
	
func ambulate(delta: float) -> void:
	velocity.x = speed * delta * direction_x
	
func apply_gravity(delta: float) -> void:
	velocity.y += gravity * delta
