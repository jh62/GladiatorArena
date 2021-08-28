class_name Map extends TileMap

var pathfinder := AStar2D.new()

func _ready() -> void:
	var cells := get_used_cells_by_id(0)
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

func add_weight_to_point(point : Vector2, amount) -> void:
	var point_id := get_id(point)
	var point_weight := pathfinder.get_point_weight_scale(point_id)
	var add_weight := clamp(point_weight + amount, 0, 10.0)
	pathfinder.set_point_weight_scale(point_id, add_weight)
	if add_weight > 1.0:
		set_cellv(point, 1)
	else:
		set_cellv(point, 0)

