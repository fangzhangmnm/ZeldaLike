# always return SUCCESS or RUNNING
@icon('../icons/succeeder.svg')
class_name BehaviorAlwaysSuccess
extends BehaviorDecorator

func tick():
    running_child=get_child(0)
    var _result=running_child._tick()
    match _result:
        SUCCESS: halt_running_child_if_any(); return SUCCESS
        FAILURE: halt_running_child_if_any(); return SUCCESS
        RUNNING: return RUNNING
    assert(false,"Will never reach here")