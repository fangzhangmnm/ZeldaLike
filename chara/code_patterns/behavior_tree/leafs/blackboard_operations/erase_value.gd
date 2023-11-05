class_name BehaviorEraseValue
extends BehaviorCondition

@export var key: String

func tick()->Result:
    blackboard.erase_value(key)
    return SUCCESS
