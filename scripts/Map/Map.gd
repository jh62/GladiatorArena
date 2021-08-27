class_name Map extends TileMap

var pathfinder := AStar2D.new()

func _ready() -> void:
	var cells := get_used_cells()
	add_points(cells)
	connect_points(cells)

func add_points(cells : PoolVector2Array) -> void:
	for cell in cells:
		var id = get_id(cell)
		pathfinder.add_point(id, cell)

func connect_points(cells : PoolVector2Array) -> void:
	for cell in cells:
		var cell_id = get_id(cell)
		var point_relatives = [
			cell + Vector2.UP,
			cell + Vector2.DOWN,
			cell + Vector2.LEFT,
			cell + Vector2.RIGHT
		]
		for point_relative in point_relatives:
			pathfinder.connect_points(cell_id, get_id(point_relative))

func get_id(point : Vector2) -> int:
	var id = point.x + (get_used_rect().size.x * point.y)
	return int(id)

func get_waypoints(point_a : Vector2, point_b : Vector2) -> PoolVector2Array:
	var from = world_to_map(point_a)
	var to = world_to_map(point_b)
	return pathfinder.get_point_path(get_id(from), get_id(to))
