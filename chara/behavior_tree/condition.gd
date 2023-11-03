class_name BehaviorCondition
extends BehaviorNode

func condition()->bool:
    return true

func tick():
    if condition(): return SUCCESS
    else: return FAILURE