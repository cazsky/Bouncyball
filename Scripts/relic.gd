extends Node2D
class_name Relic

@onready var menu: Node2D = $"../../../../../../Menu"
@onready var ball: CharacterBody2D = $"../../../../../../Ball"

@export var cost: float = 0
@export var cost_multiplier: float = 0
@export var stat_multiplier: float = 1
@export var relic_name: String
@export var level: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _upgrade() -> void:
	cost *= cost_multiplier
	level += 1
