class_name EnemyAI extends YSort

export var map : NodePath
export var update_delay := .18
export var min_mob_distance := 16.0

var tilemap : Map
var last_update := 0.0

func _ready() -> void:
	tilemap = get_node(map)

func _process(delta: float) -> void:
	last_update += delta

	var children := get_children()
	var attacking := 0

	for c in children:
		var mob : Mobile = c

		if mob.state == Mobile.State.DYING || mob.state == Mobile.State.DEAD:
			continue

		if mob.state == Mobile.State.WAITING:
			continue

		if mob.state == Mobile.State.HIT:
			continue

		if mob.state == Mobile.State.ATTACK:
			continue

		if attacking >= 1:
			mob.set_state(Mobile.State.IDLE)
			continue

		if mob.global_position.distance_to(Player.get_pos()) <= min_mob_distance:
			mob.facing = mob.global_position.direction_to(Player.get_pos()).round().x
			mob.attack()
			attacking += 1
			continue

		if last_update >= update_delay:
			var path = tilemap.get_waypoints(mob.global_position, Player.get_pos())
			mob.path = path

		if mob.path != null && !mob.path.empty():
			if mob.path_idx >= mob.path.size():
				mob.path_idx = mob.path.size() - 1
				continue

			var wp = mob.path[mob.path_idx]
			var point_dest := tilemap.map_to_world(wp)
			var dist := mob.global_position.distance_to(point_dest)

			if dist > min_mob_distance:
				var dir := mob.global_position.direction_to(point_dest).round()
				mob.dir = dir
				if dir.x != 0:
					mob.facing = dir.x
			else:
				mob.path_idx += 1
		else:
			mob.dir = Vector2.ZERO

	if last_update > update_delay:
		last_update = 0.0

