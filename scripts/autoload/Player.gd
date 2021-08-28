extends Node

var mob : Mobile

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	var dir_x := int(Input.get_action_strength("right") - Input.get_action_strength("left"))
	var dir_y := int(Input.get_action_strength("down") - Input.get_action_strength("up"))
	mob.dir.x = dir_x
	mob.dir.y = dir_y

	if dir_x != 0:
		mob.facing = dir_x

	if event.is_action_pressed("attack") && mob.state != Mobile.State.ATTACK:
		mob.attack()

func get_pos() -> Vector2:
	return mob.global_position
