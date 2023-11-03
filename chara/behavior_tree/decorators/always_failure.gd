# always return FAILURE or RUNNING
@icon('../icons/failer.svg')
class_name BehaviorAlwaysFailure
extends BehaviorDecorator


func tick():
    running_child=get_child(0)
    var result=running_child._tick()
    match result:
        SUCCESS: running_child=null; return FAILURE
        FAILURE: running_child=null; return FAILURE
        RUNNING: return RUNNING
    assert(false,"Will never reach here")