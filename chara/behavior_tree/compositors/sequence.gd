# Sequence nodes execute their children in order and fail if any child fails.
@icon('../icons/sequence.svg')
class_name BehaviorSequence
extends BehaviorCompositor

func tick():
    while next_child_index<shuffled_children.size():
        assert(running_child==null or running_child.is_running)
        assert(running_child==null or running_child==shuffled_children[next_child_index-1])
        running_child = shuffled_children[next_child_index]
        var result = running_child._tick()
        match result:
            SUCCESS: running_child=null; next_child_index+=1
            FAILURE: running_child=null; return FAILURE
            RUNNING: return RUNNING
    return SUCCESS



