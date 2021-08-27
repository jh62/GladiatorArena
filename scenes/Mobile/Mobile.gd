class_name Mobile extends KinematicBody2D

enum State {
	IDLE,
	RUN,
	ATTACK,
	KICK,
	BLOCK,
	HIT,
	DIE
}

export var max_health := 1.0
export var max_stamina := 1.0
export var speed := 60
export var side : int = Globals.Side.AI setget set_side

onready var sprite := $Sprite
onready var anim_p := $AnimationPlayer
onready var c_shape := $CollisionShape2D

var health : float setget set_health
var stamina : float setget set_stamina
var vel := Vector2()
var dir := Vector2() setget set_direction
var facing := 1 setget set_facing
var state : int = State.IDLE setget set_state

var path : PoolVector2Array
var path_idx := 0

func _ready() -> void:
	health = max_health
	stamina = max_stamina
	set_state(State.IDLE)

func _process(delta: float) -> void:
	if dir.x != 0:
		facing = dir.x
	$Sprite.flip_h = facing < 0

	match state:
		State.IDLE:
			if dir.length() != 0:
				set_state(State.RUN)
				return

			if vel.length() != 0:
				vel = vel.linear_interpolate(Vector2.ZERO, .5)
		State.RUN:
			if dir.length() == 0:
				set_state(State.IDLE)
				return

			vel += dir * speed
			vel = vel.clamped(speed)
			vel = move_and_slide(vel)

func set_state(value) -> void:
	state = value

	match state:
		State.IDLE:
			anim_p.play("idle")
		State.RUN:
			anim_p.play("run")

func set_direction(value) -> void:
	if state != State.IDLE && state != State.RUN:
		return
	dir = value

func set_facing(value) -> void:
	facing = -1 if value < 0 else 1

func set_health(value) -> void:
	health = clamp(value, 0.0, max_health)

func set_stamina(value) -> void:
	stamina = clamp(value, 0.0, max_stamina)

func set_side(value) -> void:
	side = clamp(value, 0, Globals.Side.size() - 1)
