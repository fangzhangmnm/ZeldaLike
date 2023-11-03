@tool
class_name BehaviorNode
extends Node

enum Result{
    SUCCESS,FAILURE,RUNNING
}
const SUCCESS=Result.SUCCESS
const FAILURE=Result.FAILURE
const RUNNING=Result.RUNNING

@export var reset_on_success:bool = false:
    set(value):reset_on_success=value;validate()
@export var reset_on_failure:bool = true:
    set(value):reset_on_failure=value;validate()

@export var override_success:Result = SUCCESS:
    set(value):override_success=value;validate()
@export var override_failure:Result = FAILURE:
    set(value):override_failure=value;validate()
    
@export var debug_log_reset_message=""
@export var debug_log_tick_message=""

var behavior_tree:BehaviorTree=null
var parent:BehaviorNode=null
var delta:float:
    get:return behavior_tree.delta
var blackboard:Node:
    get:return behavior_tree.blackboard

var _is_first_tick:bool=true

func enter()->Result:
    return RUNNING

func tick()->Result:
    return SUCCESS

func reset():
    pass

func _reset():
    if debug_log_reset_message!="": print(debug_log_reset_message)
    _is_first_tick=true
    reset()

func _tick()->Result:
    if debug_log_tick_message!="": print(debug_log_tick_message)
    var result:Result=RUNNING
    if _is_first_tick:
        if behavior_tree.debug_log_enter and (not "debug_log" in behavior_tree.owner or behavior_tree.owner.debug_log):
            printt("Enter behavior", name)
        result=enter()
        _is_first_tick=false
    if result==RUNNING:
        result=tick()
    result=override_result(result)
    if result==SUCCESS and reset_on_success: _reset()
    if result==FAILURE and reset_on_failure: _reset()
    behavior_tree.current_execution_path.push_front(name+"("+Result.keys()[result]+")")
    return result


func _ready():
    if Engine.is_editor_hint():
        validate()
        rename()

func rename():
    set_deferred("name",get_default_name())

func validate():
    pass

func get_default_name()->String:
    var rtval=""
    rtval=get_script().get_path()
    rtval=rtval.substr(rtval.rfind("/")+1)
    rtval=rtval.substr(0,rtval.find("."))
    return rtval
    
func override_result(result):
    if result==SUCCESS: return override_success
    if result==FAILURE: return override_failure
    return result
    
