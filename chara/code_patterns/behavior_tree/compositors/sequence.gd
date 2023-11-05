# Sequence nodes execute their children in order and fail if any child fails.
@icon('../../icons/sequence.svg')
class_name BehaviorSequence
extends BehaviorCompositor

func tick():
    while next_child_index<shuffled_children.size():
        assert(running_child==null or running_child.is_running)
        assert(running_child==null or running_child==shuffled_children[next_child_index])
        running_child = shuffled_children[next_child_index]
        var _result = running_child._tick()
        match _result:
            SUCCESS: halt_running_child_if_any(); next_child_index+=1
            FAILURE: halt_running_child_if_any(); return FAILURE
            RUNNING: return RUNNING
    halt_running_child_if_any(); return SUCCESS



