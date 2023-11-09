class_name BehaviorCopyValue
extends BehaviorAction

@export var from: StringName
@export var to: StringName

func tick()->Result:
    if not blackboard.has_value(from):
        return FAILURE
    blackboard.set_value(to, blackboard.get_value(from))
    return SUCCESS