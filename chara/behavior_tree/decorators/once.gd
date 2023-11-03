# run the child node only once
class_name BehaviorOnce
extends BehaviorDecorator

var persistent_result=RUNNING

func tick():
    if persistent_result!=RUNNING:return persistent_result
    running_child=get_child(0)
    var _result=running_child._tick()
    persistent_result=_result
    match _result:
        SUCCESS: halt_running_child_if_any(); return SUCCESS
        FAILURE: halt_running_child_if_any(); return FAILURE
        RUNNING: return RUNNING
    assert(false,"Will never reach here")

