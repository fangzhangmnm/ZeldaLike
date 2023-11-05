@icon('../../icons/sequence_reactive.svg')
class_name BehaviorSequenceReactive
extends BehaviorCompositor

func tick():
    while next_child_index<shuffled_children.size():
        # we want to check if children before the running child still returns SUCCESS
        # if they returns FAILURE or RUNNING, we need to interrupt the running child
        var next_running_child=shuffled_children[next_child_index]
        var _result=next_running_child._tick()
        match _result:
            SUCCESS: next_child_index+=1 # the running child is perserved
            FAILURE: halt_running_child_if_any(); return FAILURE
            RUNNING: 
                if running_child!=next_running_child:
                    halt_running_child_if_any()
                    running_child=next_running_child
                next_child_index=0
                return RUNNING
    halt_running_child_if_any(); return SUCCESS