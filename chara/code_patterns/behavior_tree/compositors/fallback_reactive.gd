@icon('../../icons/selector_reactive.svg')
class_name BehaviorFallbackReactive
extends BehaviorCompositor

func tick():
    while next_child_index<shuffled_children.size():
        # we want to check if children before the running child still returns FAILURE
        # if they returns SUCCESS or RUNNING, we need to interrupt the running child
        var next_running_child=shuffled_children[next_child_index]
        var _result=next_running_child._tick()
        match _result:
            SUCCESS: halt_running_child_if_any(); return SUCCESS
            FAILURE: next_child_index+=1 # the running child is perserved
            RUNNING: 
                if running_child!=next_running_child:
                    halt_running_child_if_any()
                    running_child=next_running_child
                next_child_index=0
                return RUNNING
    halt_running_child_if_any(); return FAILURE
