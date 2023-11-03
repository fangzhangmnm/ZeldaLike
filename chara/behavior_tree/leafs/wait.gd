class_name BehaviorWait
extends BehaviorNode

@export var wait_time : float = 1.0
var elapsed_time : float = 0.0

func start() -> void:
    elapsed_time = 0.0

func tick() -> Result:
    elapsed_time += delta
    if elapsed_time >= wait_time:
        return SUCCESS
    return RUNNING