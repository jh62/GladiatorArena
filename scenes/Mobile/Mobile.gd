class_name Mobile extends KinematicBody2D

enum State {
	IDLE,
	RUN,
	ATTACK,
	KICK,
	BLOCK,
	HIT,
	DYING,
	DEAD,
	WAITING
}

export var max_health := 1.0
export var max_stamina := 1.0
export var speed := 60
export var side : int = Globals.Side.AI setget set_side
export var weapon_type : PackedScene

onready var sprite := $Sprite
onready var hands := $Hands
onready var anim_p := $AnimationPlayer
onready var c_shape := $CollisionShape2D

var health : float setget set_health
var stamina : float setget set_stamina
var vel := Vector2()
var dir := Vector2() setget set_direction
var facing := 1 setget set_facing
var state : int = State.IDLE setget set_state
var weapon setget set_weapon,get_weapon

var path : PoolVector2Array setget set_path
var path_idx := 0 setget set_path_idx

func _ready() -> void:
	health = max_health
	stamina = max_stamina
	set_state(State.IDLE)
	set_weapon(weapon_type)

var h_scale := false

func set_weapon(value : PackedScene) -> void:
	var w = value.instance()
	if hands.get_child_count() != 0:
		hands.get_child(0).queue_free()
	weapon = w
	weapon.side = side
	hands.add_child(weapon)

func get_weapon() -> Weapon:
	return hands.get_child(0) as Weapon

func _process(delta: float) -> void:
	_update_animations()

	match state:
		State.IDLE:
			if $RayCast2D.is_colliding():
				return

			if dir != Vector2.ZERO:
				set_state(State.RUN)
				return

			if vel != Vector2.ZERO:
				vel = vel.linear_interpolate(Vector2.ZERO, .5)
		State.RUN:
			if dir == Vector2.ZERO:
				set_state(State.IDLE)
				return
			if $RayCast2D.is_colliding():
				set_state(State.IDLE)
				return

			vel += dir * speed
			vel = vel.clamped(speed)
			vel = move_and_slide(vel)
		State.ATTACK:
			if !weapon.is_colliding():
				weapon.on_swing()
				return

			var mob := weapon.get_collider() as Mobile

			if mob == null || mob.state == State.HIT || mob.state == State.DYING:
#				weapon.on_swing()
				return

			mob.on_hit(self)
			weapon.on_hit()
		State.HIT:
			if vel != Vector2.ZERO:
				vel = move_and_slide(vel)
		State.WAITING, State.DYING, State.DEAD:
			return

func _update_animations() -> void:
	if facing < 0 && !h_scale:
		h_scale = true
		transform.x *= -1.0
		$RayCast2D.transform.x *= -1.0
	elif facing > 0 && h_scale:
		h_scale = false
		transform.x *= -1.0
		$RayCast2D.transform.x *= -1.0

	if side == Globals.Side.AI:
		var cast_to := global_position.direction_to(Player.get_pos()).normalized() * 20.0
		$RayCast2D.cast_to = cast_to

func is_alive() -> bool:
	return state != State.DYING && state != State.DEAD

func attack() -> void:
	if state != State.IDLE && state != State.RUN:
		return

	set_state(State.ATTACK)

func move() -> void:
#	if state != State.IDLE:
#		return

	set_state(State.RUN)

func on_hit(attacker) -> void:
	health = clamp(health - 25, 0, max_health)
	vel.x = attacker.facing * 30.0
	$Particles2D.one_shot = true
	$Particles2D.emitting = true

	if health == 0:
		set_state(State.DYING)
	else:
		set_state(State.HIT)

func set_state(value) -> void:
	if !is_alive():
		return

	state = value

	match state:
		State.IDLE, State.WAITING:
			anim_p.play("idle")
			dir = Vector2.ZERO
		State.RUN:
			anim_p.play("run")
		State.ATTACK:
			anim_p.play("attack")
		State.HIT:
			anim_p.play("hit")
		State.DYING:
			anim_p.play("die")
			get_node("CollisionShape2D").queue_free()

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

func set_path(value) -> void:
	path = value

func set_path_idx(value) -> void:
	path_idx = clamp(value, 0, path.size() - 1)

func set_weapon_enabled(value := true) -> void:
	weapon.enabled = value
	weapon.force_raycast_update()

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	match state:
		State.ATTACK:
			if side == Globals.Side.AI:
				set_state(State.WAITING)
				yield(get_tree().create_timer(1.71),"timeout")
			set_state(State.IDLE)
		State.HIT:
			set_state(State.IDLE)
		State.DYING:
			set_state(State.DEAD)
