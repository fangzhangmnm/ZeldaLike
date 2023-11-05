@icon('../../icons/sequence.svg')
class_name BehaviorSequenceWithMemory
extends BehaviorCompositor

# when FAILED, remember the current index and restore it when the sequence is started again

var persistent_index = 0

func tick():
    while next_child_index<shuffled_children.size():
        assert(running_child==null or running_child.is_running)
        assert(running_child==null or running_child==shuffled_children[next_child_index])
        running_child = shuffled_children[next_child_index]
        var _result = running_child._tick()
        match _result:
            SUCCESS: running_child=null; next_child_index+=1
            FAILURE: 
                
                persistent_index = next_child_index
                halt_running_child_if_any(); return FAILURE
            RUNNING: return RUNNING
    halt_running_child_if_any(); return SUCCESS

func start():
    super()
    next_child_index = persistent_index
