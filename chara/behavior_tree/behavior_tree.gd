class_name BehaviorTree
extends Node

@onready var root:BehaviorNode=get_child(0) #root node of the tree

@export var blackboard:Node=null #anything that can be used to store data

enum Tick_Behavior{PROCESS,PHYSICS_PROCESS,EXTERNAL}
@export var tick_behavior:Tick_Behavior=Tick_Behavior.PHYSICS_PROCESS

var delta:float=0.0 #time since last tick


func _ready():
    root.behavior_tree=self
    root._reset()

func tick(_delta):
    delta=_delta
    root._tick()

func _process(_delta):
    if tick_behavior==Tick_Behavior.PROCESS:
        tick(_delta)

func _physics_process(_delta):
    if tick_behavior==Tick_Behavior.PHYSICS_PROCESS:
        tick(_delta)
