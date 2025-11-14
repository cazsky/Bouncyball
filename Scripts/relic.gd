extends Node2D
class_name Relic

@onready var menu: Node2D = $"../../../../../../../../Menu"
@onready var ball: CharacterBody2D = get_tree().current_scene.get_node("Ball")
@onready var label: Label = $Label


var cost: float = 0
var cost_multiplier: float = 0
var stat_multiplier: float = 1
var relic_name: String
var level: int = 1
var relic_effect: String
var scene_path: String
var relic_id: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await ready
	
	
func _upgrade() -> void:
	cost *= cost_multiplier
	level += 1

func _activate_effect() -> void:
	#menu = await wait_for_node("../../../../../../../../Menu")
	menu.set(relic_effect, menu.get(relic_effect) * stat_multiplier)
	update_label()


func _on_tree_entered() -> void:
	await ready
	
	_activate_effect()
	update_label()
	
func wait_for_node(path: NodePath) -> Node:
	var node = get_node_or_null(path)
	while node == null:
		await get_tree().process_frame
		node = get_node_or_null(path)
	return node

func update_label() -> void:
	label.text = "%s: +%s%%" % [relic_effect, stat_multiplier]
