class_name BehaviorMath
extends BehaviorAction

@export var immediates:={
    "A": 0,
    "B": 1,
}
@export var A_key:StringName=""
@export var B_key:StringName=""
@export var operation:OPERATION=OPERATION.ADD
@export var output_key:StringName=""

enum OPERATION{
    COPY_A,ADD,SUBSTRACT,MULTIPLY,DIVIDE,MODULO,POWER,MIN,MAX
}

func tick()->Result:
    var A=immediates["A"]
    var B=immediates["B"]
    if A_key!="":
        if not blackboard.has_value(A_key): return FAILURE
        A=blackboard.get_value(A_key)
    if B_key!="":
        if not blackboard.has_value(B_key): return FAILURE
        B=blackboard.get_value(B_key)
    var C=0
    match operation:
        OPERATION.COPY_A:
            C=A
        OPERATION.ADD:
            C=A+B
        OPERATION.SUBSTRACT:
            C=A-B
        OPERATION.MULTIPLY:
            C=A*B
        OPERATION.DIVIDE:
            if B==0: return FAILURE
            C=A/B
        OPERATION.MODULO:
            if B==0: return FAILURE
            C=A%B
        OPERATION.POWER:
            if A<0 and B%1!=0: return FAILURE
            C=A**B
        OPERATION.MIN:
            C=min(A,B)
        OPERATION.MAX:
            C=max(A,B)
    if output_key!="":
        blackboard.set_value(output_key,C)
    return SUCCESS