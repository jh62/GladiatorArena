extends Node

var mob : Mobile

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var dir_x := int(Input.get_action_strength("right") - Input.get_action_strength("left"))
	var dir_y := int(Input.get_action_strength("down") - Input.get_action_strength("up"))
	mob.dir.x = dir_x
	mob.dir.y = dir_y

func get_pos() -> Vector2:
	return mob.global_position
