extends Node2D
class_name Relic

@onready var menu: Node2D = $"../../../../../../Menu"
#@export var ball_path: NodePath
#@onready var ball: CharacterBody2D = get_node("NodePath")
@onready var ball: CharacterBody2D = get_tree().current_scene.get_node("Ball")

var cost: float = 0
var cost_multiplier: float = 0
var stat_multiplier: float = 1
var relic_name: String
var level: int = 1
var relic_effect: String
var scene_path: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	
func _upgrade() -> void:
	cost *= cost_multiplier
	level += 1

func _activate_effect() -> void:
	print_debug("Parent relic")
	pass


func _on_tree_entered() -> void:
	_activate_effect()
	
func wait_for_node(path: NodePath) -> Node:
	var node = get_node_or_null(path)
	while node == null:
		await get_tree().process_frame
		node = get_node_or_null(path)
	return node
