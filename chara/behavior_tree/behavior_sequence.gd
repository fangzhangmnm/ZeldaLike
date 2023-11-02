@tool
class_name BehaviorSequence
extends BehaviorCompositor

func tick()->Result:
    if shuffled_children.size()!=get_child_count(): _reset()
    if not stateful: current_child=0
    while current_child<len(shuffled_children):
        var result:Result=shuffled_children[current_child]._tick()
        if result==RUNNING: return RUNNING
        elif result==FAILURE: return FAILURE
        else: current_child+=1
    return SUCCESS

func get_default_name()->String:
    var rtval="Sequence"
    if random: rtval+="?"
    if stateful: rtval+="*"
    return rtval