# SequenceParallel nodes execute their children in parallel and fail if any child fails.
@icon('../icons/sequence.svg')
class_name BehaviorSequenceParallel
extends BehaviorCompositorParallel

func tick():
    for rc in running_children: assert(rc.is_running)
    var success_count = 0
    for idx in range(shuffled_children.size()):
        var child = shuffled_children[idx]
        var result = child._tick()
        match result:
            SUCCESS: success_count+=1; running_children.erase(child); continue
            FAILURE: halt_running_children_if_any(); return FAILURE
            RUNNING: running_children.append(child); continue
    if success_count == shuffled_children.size():return SUCCESS
    else: return RUNNING

