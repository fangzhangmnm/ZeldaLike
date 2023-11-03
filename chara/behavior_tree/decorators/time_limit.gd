# fails if timeout
class_name BehaviorTimeLimit
extends BehaviorDecorator

@export var time_limit:float=1.0

var time_elapsed:float=0.0

func start():
    super()
    time_elapsed=0

func tick():
    if time_elapsed>time_limit:
        halt_running_child_if_any()
        return FAILURE
    else:
        time_elapsed+=delta
        running_child=get_child(0)
        var result=running_child._tick()
        return result

