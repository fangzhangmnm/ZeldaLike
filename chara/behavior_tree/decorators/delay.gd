# reduce the child's tick frequency
class_name BehaviorDelay
extends BehaviorDecorator

@export var delay_time:float=1.0

var count_down:float=0.0

func start():
    super()
    count_down=0

func tick():
    if count_down>0: count_down-=delta; return RUNNING
    running_child=get_child(0)
    var result=running_child._tick()
    match result:
        SUCCESS: return SUCCESS
        FAILURE: return FAILURE
        RUNNING: count_down=delay_time; return RUNNING
    assert(false,"Will never reach here")

