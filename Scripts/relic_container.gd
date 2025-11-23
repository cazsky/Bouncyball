extends VBoxContainer
class_name Relic_Container

@export var wrapper_class: String = "Control"

func add_wrapped_child(child: Node) -> void:
	var wrapper: Control
	wrapper = ClassDB.instantiate(wrapper_class)
	wrapper.name = "Control_Wrapper_%s" % child.name
	wrapper.set_custom_minimum_size(Vector2(0,50))
	
	# Add child to control node
	wrapper.add_child(child)
	
	# Add control node to grid container
	add_child(wrapper)
