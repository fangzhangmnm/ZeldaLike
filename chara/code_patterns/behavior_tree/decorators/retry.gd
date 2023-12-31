# Repeats the child up until success
@icon('../../icons/limiter.svg')
class_name BehaviorRetry
extends BehaviorDecorator

@export var num_attempts:int=5
@export var forever:bool=false
var current_attempt=0

func start():
    super()
    current_attempt=0

func tick():
    while current_attempt<num_attempts:
        assert(running_child==null or running_child.is_running)
        running_child=get_child(0)
        var _result=running_child._tick()
        match _result:
            SUCCESS: halt_running_child_if_any(); return SUCCESS
            FAILURE: halt_running_child_if_any(); current_attempt+=1
            RUNNING: return RUNNING
        if forever: return RUNNING # to avoid infinite loop if child always returns FAILURE
    return FAILURE
