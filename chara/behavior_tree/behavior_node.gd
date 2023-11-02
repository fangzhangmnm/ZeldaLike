class_name BehaviorNode
extends Node

enum Result{
    SUCCESS,FAILURE,RUNNING
}
const SUCCESS=Result.SUCCESS
const FAILURE=Result.FAILURE
const RUNNING=Result.RUNNING

enum Type{LEAF,SELECTOR,SEQUENCE}
enum Override_Result{NONE,SUCCESS,FAILURE,INVERT}

@export var type:Type = Type.LEAF
@export var stateful:bool = false
@export var random:bool = false
@export var reset_on_success:bool = false
@export var reset_on_failure:bool = false

var behavior_tree:BehaviorTree=null
var parent:BehaviorNode=null
var delta:float:
    get:return behavior_tree.delta
var blackboard:Node:
    get:return behavior_tree.blackboard

var shuffled_children:Array[Node] = []
var current_child:int=0

func tick()->Result:
    return SUCCESS

func reset():
    pass

func _reset():
    shuffled_children=get_children()
    if random: shuffled_children.shuffle()
    current_child=0
    for child in shuffled_children:
        child.parent=self
        child.behavior_tree=self.behavior_tree
        child._reset()
    reset()

func _tick()->Result:
    if shuffled_children.size()!=get_child_count(): _reset()
    var result:Result
    if type==Type.LEAF:
        result=tick()
    elif type==Type.SELECTOR:
        result=_selector()
    elif type==Type.SEQUENCE:
        result=_sequence()
    if result==SUCCESS and reset_on_success: _reset()
    if result==FAILURE and reset_on_failure: _reset()
    return result

func _selector()->Result:
    if not stateful: current_child=0
    while current_child<len(shuffled_children):
        var result:Result=shuffled_children[current_child]._tick()
        if result==RUNNING: return RUNNING
        elif result==SUCCESS: return SUCCESS
        else: current_child+=1
    return FAILURE

func _sequence()->Result:
    if not stateful: current_child=0
    while current_child<len(shuffled_children):
        var result:Result=shuffled_children[current_child]._tick()
        if result==RUNNING: return RUNNING
        elif result==FAILURE: return FAILURE
        else: current_child+=1
    return SUCCESS
