# run the child node only once
class_name BehaviorOnce
extends BehaviorDecorator

var persistent_result=RUNNING


enum Behavior{RETICK,KEEP_FAILURE}
@export var halt_behavior:=Behavior.KEEP_FAILURE
@export var failure_behavior:=Behavior.KEEP_FAILURE


func tick():
    if persistent_result!=RUNNING:return persistent_result
    running_child=get_child(0)
    var _result=running_child._tick()
    match _result:
        SUCCESS: 
            halt_running_child_if_any()
            persistent_result=SUCCESS; return SUCCESS
        FAILURE: 
            halt_running_child_if_any(); 
            match failure_behavior:
                Behavior.KEEP_FAILURE: persistent_result=FAILURE; return FAILURE
                Behavior.RETICK: persistent_result=RUNNING; return RUNNING
            assert(false,"Will never reach here")
        RUNNING: return RUNNING
    assert(false,"Will never reach here")

func halt():
    match halt_behavior:
        Behavior.KEEP_FAILURE: persistent_result=FAILURE
        Behavior.RETICK: persistent_result=RUNNING
    super()
