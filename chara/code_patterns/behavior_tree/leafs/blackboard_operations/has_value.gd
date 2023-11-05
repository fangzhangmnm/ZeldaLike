class_name BehaviorHasValue
extends BehaviorCondition

@export var key: String

func condition()->bool:
    printt("has value:", key, blackboard.has_value(key))
    return blackboard.has_value(key)