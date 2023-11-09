class_name BehaviorEraseValue
extends BehaviorAction

@export var key: StringName

func tick()->Result:
    blackboard.erase_value(key)
    return SUCCESS
