@icon('../icons/selector_reactive.svg')
class_name BehaviorFallbackReactive
extends BehaviorCompositor

func tick():
    while next_child_index<shuffled_children.size():
        assert(running_child==null or running_child.is_running)
        # we want to check if children before the running child still returns FAILURE
        # if they returns SUCCESS or RUNNING, we need to interrupt the running child
        var next_running_child=shuffled_children[next_child_index]
        var result=next_running_child._tick()
        match result:
            SUCCESS: halt_running_child_if_any(); return SUCCESS
            FAILURE: next_child_index+=1
            RUNNING: 
                if running_child!=next_running_child:
                    halt_running_child_if_any()
                    running_child=next_running_child
                return RUNNING
    return FAILURE