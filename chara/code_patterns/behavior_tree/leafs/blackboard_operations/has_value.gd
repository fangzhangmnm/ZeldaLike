class_name BehaviorHasValue
extends BehaviorCondition

@export var key: StringName

func condition()->bool:
    # printt("has value:", key, blackboard.has_value(key))
    return blackboard.has_value(key)