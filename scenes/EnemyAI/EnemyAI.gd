class_name EnemyAI extends YSort

export var map : NodePath

var tilemap : Map
var last_update := 0.0

func _ready() -> void:
	tilemap = get_node(map)

var pa
var pb

func _input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		pa = get_global_mouse_position()
		pb = null
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		pb = Player.get_pos()

	if pb != null:
		var p = tilemap.get_waypoints(pa,pb)
		print_debug(p)
		pb = null

func _process(delta: float) -> void:
	last_update += delta

	var children := get_children()

	for c in children:
		var mob : Mobile = c

#		if mob.global_position.distance_to(Player.get_pos()) < 16.0:
#			continue

		if last_update >= 0.33:
			var path = tilemap.get_waypoints(mob.global_position, Player.get_pos())
			mob.path = path
			continue

		if mob.path != null && !mob.path.empty():
			if mob.path_idx >= mob.path.size():
				mob.dir = Vector2.ZERO
				continue

			var wp = mob.path[mob.path_idx]
			var point_dest := tilemap.map_to_world(wp)
			var dist := mob.global_position.distance_to(point_dest)

			if dist > 0.5:
				var dir := mob.global_position.direction_to(point_dest).round()
				mob.dir = dir
			else:
				mob.path_idx = clamp(mob.path_idx + 1, 0, mob.path.size() - 1)

	if last_update > .33:
		last_update = 0.0


