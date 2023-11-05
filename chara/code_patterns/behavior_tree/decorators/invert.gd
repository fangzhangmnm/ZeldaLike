# swap the SUCCESS and FAILURE results of the child node
@icon('../../icons/inverter.svg')
class_name BehaviorInvert
extends BehaviorDecorator


func tick():
    running_child=get_child(0)
    var _result=running_child._tick()
    match _result:
        SUCCESS: halt_running_child_if_any(); return FAILURE
        FAILURE: halt_running_child_if_any(); return SUCCESS
        RUNNING: return RUNNING
    assert(false,"Will never reach here")