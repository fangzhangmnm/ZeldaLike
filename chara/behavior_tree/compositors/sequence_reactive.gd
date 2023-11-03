@icon('../icons/sequence_reactive.svg')
class_name BehaviorSequenceReactive
extends BehaviorCompositor

func tick():
    while next_child_index<shuffled_children.size():
        assert(running_child==null or running_child.is_running)
        # we want to check if children before the running child still returns SUCCESS
        # if they returns FAILURE or RUNNING, we need to interrupt the running child
        var next_running_child=shuffled_children[next_child_index]
        var result=next_running_child._tick()
        match result:
            SUCCESS: next_child_index+=1
            FAILURE: halt_running_child_if_any(); return FAILURE
            RUNNING: 
                if running_child!=next_running_child:
                    halt_running_child_if_any()
                    running_child=next_running_child
                return RUNNING
    return FAILURE