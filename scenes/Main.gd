extends Node2D

onready var tilemap := $Map
onready var static_entities := $Statics
onready var player := $YSort/Player

func _ready() -> void:
	Player.mob = $YSort/Player

func _process(delta: float) -> void:
	pass
