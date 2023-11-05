@icon('../icons/tree.svg')
class_name BehaviorTree
extends Node

signal success
signal failure

@onready var root:BehaviorNode=get_child(0)

enum Tick_Behavior{PROCESS,PHYSICS_PROCESS,EXTERNAL}
@export var tick_behavior:Tick_Behavior=Tick_Behavior.PHYSICS_PROCESS
@export var restart:bool=false
@export var blackboard:Node
@export var actor:Node
@export var debug_log:bool=false

var delta:float=0.0 #time since last tick

var result:BehaviorNode.Result=BehaviorNode.Result.RUNNING

var execution_path:Array[BehaviorNode]=[]

func _ready():
    root.behavior_tree=self
    root.parent=null
    result=BehaviorNode.Result.RUNNING
    if not is_instance_valid(blackboard) and owner.has_node("Blackboard"):
        blackboard=owner.get_node("Blackboard")
    if not is_instance_valid(actor):actor=owner

func tick(_delta):
    if result==BehaviorNode.Result.RUNNING:
        delta=_delta
        execution_path.clear()
        result=root._tick()

        if debug_log and (not('debug_log' in actor) or actor.debug_log):
            print(actor.name+" "+get_execution_path_string())

        if result==BehaviorNode.Result.SUCCESS: success.emit()
        elif result==BehaviorNode.Result.FAILURE: failure.emit()

        if restart: result=BehaviorNode.Result.RUNNING

func interrupt():
    root._interrupt()

func _process(_delta):
    if tick_behavior==Tick_Behavior.PROCESS:
        delta=_delta
        tick(_delta)

func _physics_process(_delta):
    if tick_behavior==Tick_Behavior.PHYSICS_PROCESS:
        delta=_delta
        tick(_delta)

func get_execution_path_string():
    var s=""
    # var last=null
    # for n in execution_path:
    #     if n.is_running:
    #         s+=" > "+n.name
    # if last and not last.is_running:
    #     s+=" > "+last.name
    s+=" : "+BehaviorNode.Result.keys()[result]
    for n in execution_path:
        s+=" > "+n.name
        s+=":"+BehaviorNode.Result.keys()[n.result]
    return s
    
