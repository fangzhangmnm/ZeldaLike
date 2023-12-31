# Repeats the child up to num_cycle times as long as the child returns SUCCESS
@icon('../../icons/limiter.svg')
class_name BehaviorRepeat
extends BehaviorDecorator

@export var num_cycles:int=5
@export var forever:bool=false
var current_cycle=0

func start():
    super()
    current_cycle=0

func tick():
    while current_cycle<num_cycles or forever:
        assert(running_child==null or running_child.is_running)
        running_child=get_child(0)
        var _result=running_child._tick()
        match _result:
            SUCCESS: halt_running_child_if_any(); current_cycle+=1;
            FAILURE: halt_running_child_if_any(); return FAILURE
            RUNNING: return RUNNING
        if forever: return RUNNING # to avoid infinite loop if child always returns SUCCESS
    return SUCCESS

