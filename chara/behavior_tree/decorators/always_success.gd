# always return SUCCESS or RUNNING
@icon('../icons/succeeder.svg')
class_name BehaviorAlwaysSuccess
extends BehaviorDecorator


func tick():
    running_child=get_child(0)
    var result=running_child._tick()
    match result:
        SUCCESS: running_child=null; return SUCCESS
        FAILURE: running_child=null; return SUCCESS
        RUNNING: return RUNNING
    assert(false,"Will never reach here")