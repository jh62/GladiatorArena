class_name Weapon extends RayCast2D

const SOUNDS := {
	"hit":[
		preload("res://assets/sfx/sword_impact_1.wav"),
		preload("res://assets/sfx/sword_impact_2.wav"),
		preload("res://assets/sfx/sword_impact_3.wav")
	],
	"swing":[
		preload("res://assets/sfx/sword_swing_1.wav")
	]
}

export var side : int = Globals.Side.AI setget set_side

func _ready() -> void:
	pass

func on_swing()-> void:
	$AudioStreamPlayer2D.stream = SOUNDS.swing[0]
	$AudioStreamPlayer2D.pitch_scale = rand_range(.95,1.05)
	$AudioStreamPlayer2D.play()

func on_hit()-> void:
	randomize()
	SOUNDS.hit.shuffle()
	$AudioStreamPlayer2D.stream = SOUNDS.hit[0]
	$AudioStreamPlayer2D.pitch_scale = rand_range(.95,1.05)
	$AudioStreamPlayer2D.play()

func set_side(value) -> void:
	side = value

	match side:
		Globals.Side.AI:
			set_collision_mask_bit(1, true)
		Globals.Side.PLAYER:
			set_collision_mask_bit(2, true)


	force_raycast_update()
