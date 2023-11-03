class_name BehaviorTree
extends Node

@onready var root:BehaviorNode=get_child(0) #root node of the tree

@export var blackboard:Node=null #anything that can be used to store data

enum Tick_Behavior{PROCESS,PHYSICS_PROCESS,EXTERNAL}
@export var tick_behavior:Tick_Behavior=Tick_Behavior.PHYSICS_PROCESS

@export var debug_log_enter:bool=false
@export var debug_log_current_path:bool=false

var delta:float=0.0 #time since last tick
var current_execution_path=[]


func _ready():
    root.behavior_tree=self
    root._reset()

func tick(_delta):
    current_execution_path.clear()
    delta=_delta
    var result=root._tick()
    if debug_log_current_path and (not "debug_log" in owner or owner.debug_log):
        print("BehaviorTree: "+"->".join(current_execution_path)+":"+BehaviorNode.Result.keys()[result])

func _process(_delta):
    if tick_behavior==Tick_Behavior.PROCESS:
        tick(_delta)

func _physics_process(_delta):
    if tick_behavior==Tick_Behavior.PHYSICS_PROCESS:
        tick(_delta)
