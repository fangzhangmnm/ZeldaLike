@tool
class_name BehaviorSelectorNode
extends BehaviorCompositor

func tick()->Result:
    if shuffled_children.size()!=get_child_count(): _reset()
    if not stateful: current_child=0
    while current_child<len(shuffled_children):
        var result:Result=shuffled_children[current_child]._tick()
        if result==RUNNING: return RUNNING
        if result==SUCCESS: return SUCCESS
        behavior_tree.current_execution_path.pop_back()
        current_child+=1
    return FAILURE

func get_default_name()->String:
    var rtval="Selector"
    if random: rtval+="?"
    if stateful: rtval+="*"
    return rtval