# FallbackParallel nodes execute their children in parallel and succeed if any child succeed, 
# then halt the other children.
@icon('../../icons/selector.svg')
class_name BehaviorFallbackParallel
extends BehaviorCompositorParallel

func tick():
    for rc in running_children: assert(rc.is_running)
    var failure_count = 0
    for idx in range(shuffled_children.size()):
        var child = shuffled_children[idx]
        var _result = child._tick()
        match _result:
            SUCCESS: halt_running_children_if_any(); return SUCCESS
            FAILURE: failure_count += 1; running_children.erase(child); continue
            RUNNING: running_children.append(child); continue
    if failure_count == shuffled_children.size():
        halt_running_children_if_any(); return FAILURE
    else: return RUNNING


