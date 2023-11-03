# run the child node only once
class_name BehaviorOnce
extends BehaviorDecorator

var persistent_result=RUNNING

func tick():
    if persistent_result!=RUNNING:return persistent_result
    running_child=get_child(0)
    var result=running_child._tick()
    persistent_result=result
    match result:
        SUCCESS: running_child=null; return SUCCESS
        FAILURE: running_child=null; return FAILURE
        RUNNING: return RUNNING
    assert(false,"Will never reach here")

