extends TileMapLayer

func is_obstacle() -> bool:
	return true

func explode() -> void:
	queue_free()
