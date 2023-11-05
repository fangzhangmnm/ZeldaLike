# Fallback Nodes execute their children in order until one succeeds.

@icon('../../icons/selector.svg')
class_name BehaviorFallback
extends BehaviorCompositor

func tick():
    while next_child_index<shuffled_children.size():
        assert(running_child==null or running_child.is_running)
        assert(running_child==null or running_child==shuffled_children[next_child_index])
        running_child = shuffled_children[next_child_index]
        var _result = running_child._tick()
        match _result:
            SUCCESS: running_child=null; return SUCCESS
            FAILURE: running_child=null; next_child_index+=1
            RUNNING: return RUNNING
    halt_running_child_if_any(); return FAILURE


    