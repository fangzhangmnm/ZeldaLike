@tool
class_name BehaviorRepeater
extends BehaviorCompositor


enum RepeatMode{REPEAT,UNTIL_SUCCESS,UNTIL_FAILURE}

@export var repeat_mode:RepeatMode = RepeatMode.UNTIL_FAILURE:
    set(value):repeat_mode=value;validate()

@export var max_repeat_times:int = -1:
    set(value):max_repeat_times=value;validate()
    
@export var result_on_max_repeat_exceeded:Result = SUCCESS:
    set(value):result_on_max_repeat_exceeded=value;validate()

@export var reset_child_on_repeat:bool = true:
    set(value):reset_child_on_repeat=value;validate()
    
var current_repeat_count:int = 0
var child:Node


func reset():
    current_repeat_count=0
    child=get_child(0)
    child.parent=self
    child.behavior_tree=behavior_tree
    child._reset()

func tick()->Result:
    if current_repeat_count<max_repeat_times or max_repeat_times<0:
        var result=child._tick()
        if result!=RUNNING:
            current_repeat_count+=1
            if reset_child_on_repeat: child._reset()
        if result==FAILURE and repeat_mode==RepeatMode.UNTIL_FAILURE:
            return FAILURE
        if result==SUCCESS and repeat_mode==RepeatMode.UNTIL_SUCCESS:
            return SUCCESS
        return RUNNING
    else:
        return result_on_max_repeat_exceeded

func get_default_name()->String:
    var rtval=""
    if max_repeat_times<0:
        if repeat_mode==RepeatMode.REPEAT: rtval="Forever"
        elif repeat_mode==RepeatMode.UNTIL_FAILURE: rtval="UntilFailure"
        elif repeat_mode==RepeatMode.UNTIL_SUCCESS: rtval="UntilSuccess"
    else:
        if repeat_mode==RepeatMode.REPEAT: rtval="RepeatWhatever"
        elif repeat_mode==RepeatMode.UNTIL_FAILURE: rtval="Repeat"
        elif repeat_mode==RepeatMode.UNTIL_SUCCESS: rtval="Try"
        rtval+=" "+str(max_repeat_times)+" Times"
    if not reset_child_on_repeat: rtval+=" (NoReset)"
    return rtval

func validate():
    super()
    if max_repeat_times<0 and max_repeat_times!=-1: max_repeat_times=-1
    if repeat_mode==RepeatMode.UNTIL_FAILURE and result_on_max_repeat_exceeded!=SUCCESS: result_on_max_repeat_exceeded=SUCCESS
    if repeat_mode==RepeatMode.UNTIL_SUCCESS and result_on_max_repeat_exceeded!=FAILURE: result_on_max_repeat_exceeded=FAILURE
