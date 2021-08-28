extends Node2D

onready var tilemap := $Map
onready var static_entities := $Statics
onready var player := $YSort/Player

func _ready() -> void:
	Player.mob = $YSort/Player

func _process(delta: float) -> void:
	$CanvasLayer/TextureProgress.value = Player.mob.max_health * (Player.mob.health / Player.mob.max_health)
