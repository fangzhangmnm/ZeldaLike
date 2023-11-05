@icon('../icons/category_bt.svg')
class_name BehaviorNode
extends Node

enum Result{
    RUNNING,SUCCESS,FAILURE
}
const RUNNING=Result.RUNNING
const SUCCESS=Result.SUCCESS
const FAILURE=Result.FAILURE

var behavior_tree:BehaviorTree=null
var parent:BehaviorNode=null
var delta:float:
    get:return behavior_tree.delta
var blackboard:Blackboard:
    get:return behavior_tree.blackboard
var actor:Node:
    get:return behavior_tree.actor
var is_running:bool=false
var result:Result=RUNNING


func start()->void:
    pass

func tick()->Result:
    return SUCCESS

func finish()->void:
    pass

func halt()->void:
    pass

func cleanup()->void: # finish or halt
    pass

func _tick()->Result:
    behavior_tree.execution_path.push_back(self)
    if not is_running:
        is_running=true
        start()
    result=tick()
    if result!=RUNNING:
        is_running=false
        finish()
        cleanup()
    return result

func _halt()->void: # certain nodes have different behavior on halt and finish
    if is_running:
        is_running=false
        halt()
        cleanup()
        
func _set_parent(_parent:BehaviorNode)->void:
    self.parent=_parent
    self.behavior_tree=_parent.behavior_tree
