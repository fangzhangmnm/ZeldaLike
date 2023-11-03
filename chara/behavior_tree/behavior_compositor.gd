@tool
class_name BehaviorCompositor
extends BehaviorNode

@export var stateful:bool = false:
    set(value):stateful=value;validate();rename()
@export var random:bool = false:
    set(value):random=value;validate();rename()

var shuffled_children:Array[Node] = []
var current_child:int=0

func reset():
    shuffled_children=get_children()
    if random: shuffled_children.shuffle()
    current_child=0
    for child in shuffled_children:
        child.parent=self
        child.behavior_tree=self.behavior_tree
        child._reset()
