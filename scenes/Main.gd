extends Node2D

func _process(delta: float) -> void:
	var mouse_pos := to_local(get_global_mouse_position())
	$Position2D.global_position = mouse_pos
