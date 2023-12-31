# reduce the child's tick frequency
class_name BehaviorDelay
extends BehaviorDecorator

@export var delay_time:float=1.0

var count_down:float=0.0

func start():
    super()
    count_down=0

func tick():
    if count_down>0: 
        count_down-=delta
        return RUNNING
    else:
        running_child=get_child(0)
        var _result=running_child._tick()
        match _result:
            SUCCESS: halt_running_child_if_any(); return SUCCESS
            FAILURE: halt_running_child_if_any(); return FAILURE
            RUNNING: count_down=delay_time; return RUNNING
        assert(false,"Will never reach here")

