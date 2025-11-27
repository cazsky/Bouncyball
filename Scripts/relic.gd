extends Node2D
class_name Relic

@onready var menu: Node2D = $"../../../../../../../../Menu"
@onready var ball: CharacterBody2D = get_tree().current_scene.get_node("Ball")
@onready var label: Label = $Label
@onready var upgrade_button: RelicUpgradeButton = $RelicUpgradeButton
@onready var relic_container: Control = get_parent()

var cost: float = 0
var cost_multiplier: float = 0
var stat_multiplier: float = 1
var relic_name: String
var level: int = 1
var relic_effect: String
var scene_path: String
var relic_id: int
var relic_number: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await ready # Necessary for some reason
	
func _upgrade() -> void:
	cost *= cost_multiplier
	level += 1

func _activate_effect() -> void:
	menu.set(relic_effect, menu.get(relic_effect) * stat_multiplier)
	upgrade_button.update_label(cost)
	update_label()


func _on_tree_entered() -> void:
	await ready # Necessary for some reason
	_activate_effect()
	
func wait_for_node(path: NodePath) -> Node:
	var node = get_node_or_null(path)
	while node == null:
		await get_tree().process_frame
		node = get_node_or_null(path)
	return node
	
func update_label() -> void:
	label.text = "%s: +%s%%" % [relic_effect, stat_multiplier]

func _on_relic_upgrade_button_pressed() -> void:
	upgrade_button.update_label(cost)
