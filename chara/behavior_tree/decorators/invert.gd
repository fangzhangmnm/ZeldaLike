# swap the SUCCESS and FAILURE results of the child node
@icon('../icons/inverter.svg')
class_name BehaviorInvert
extends BehaviorDecorator


func tick():
    running_child=get_child(0)
    var result=running_child._tick()
    match result:
        SUCCESS: running_child=null; return FAILURE
        FAILURE: running_child=null; return SUCCESS
        RUNNING: return RUNNING
    assert(false,"Will never reach here")