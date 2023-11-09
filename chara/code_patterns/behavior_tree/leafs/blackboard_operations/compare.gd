class_name BehaviorCompare
extends BehaviorCondition

@export var immediates:={
    "A": 0,
    "B": 1,
}
@export var A_key:StringName=""
@export var B_key:StringName=""
@export var operation:OPERATION=OPERATION.EQUAL
@export var output_key:StringName=""

enum OPERATION{
    A,NOT_A,EQUAL,NOT_EQUAL,LESS,GREATER,LESS_EQUAL,GREATER_EQUAL,
}

func condition()->bool:
    var A=immediates["A"]
    var B=immediates["B"]
    if A_key!="":
        if not blackboard.has_value(A_key): return FAILURE
        A=blackboard.get_value(A_key)
    if B_key!="":
        if not blackboard.has_value(B_key): return FAILURE
        B=blackboard.get_value(B_key)
    match operation:
        OPERATION.A:
            return A
        OPERATION.NOT_A:
            return not A
        OPERATION.EQUAL:
            return A==B
        OPERATION.NOT_EQUAL:
            return A!=B
        OPERATION.LESS:
            return A<B
        OPERATION.GREATER:
            return A>B
        OPERATION.LESS_EQUAL:
            return A<=B
        OPERATION.GREATER_EQUAL:
            return A>=B
    return false