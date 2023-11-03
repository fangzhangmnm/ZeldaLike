# Fallback Nodes execute their children in order until one succeeds.

class_name BehaviorFallback
extends BehaviorCompositor

func tick():
    while next_child_index<shuffled_children.size():
        assert(running_child==null or running_child.is_running)
        assert(running_child==null or running_child==shuffled_children[next_child_index-1])
        running_child = shuffled_children[next_child_index]
        var result = running_child._tick()
        match result:
            SUCCESS: running_child=null; return SUCCESS
            FAILURE: running_child=null; next_child_index+=1
            RUNNING: return RUNNING
    return FAILURE


    