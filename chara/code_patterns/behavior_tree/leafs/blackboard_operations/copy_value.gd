class_name BehaviorCopyValue
extends BehaviorCondition

@export var from: String
@export var to: String
@export var check_failure: bool = false

func tick()->Result:
    if check_failure:
        if not blackboard.has_value(from):
            return FAILURE
    blackboard.set_value(to, blackboard.get_value(from))
    return SUCCESS