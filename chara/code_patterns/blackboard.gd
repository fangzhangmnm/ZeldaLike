@icon('./icons/blackboard.svg')
class_name Blackboard
extends Node

@export var blackboard:Dictionary={}
@export var use_owner_blackboard:bool=false
@export var owner_inherits_my_blackboard:bool=false

@export var debug_log_value_changes:bool=false

var blackboard_node:Node=null

func _ready()->void:
    if use_owner_blackboard:
        if owner_inherits_my_blackboard:
            for key in blackboard.keys():
                if key not in owner.blackboard:
                    owner.blackboard[key]=blackboard[key]
        blackboard=owner.blackboard
        blackboard_node=owner
    else:
        blackboard_node=self
        


func keys()->Array[String]:
    return blackboard.keys().duplicate()

func set_value(key:Variant,value:Variant)->void:
    if debug_log_value_changes and (not "debug_log" in owner or owner.debug_log):
        if get_value(key)!=value:
            print(owner.name+" set "+key+" to "+str(value))
    blackboard[key]=value

func has_value(key:Variant)->bool:
    return key in blackboard and blackboard[key]!=null

func get_value(key:Variant,default:Variant=null)->Variant:
    if has_value(key):
        var rtval=blackboard[key]
        if rtval is NodePath:
            rtval=blackboard_node.get_node(rtval)
        return rtval
    return default

func erase_value(key:Variant)->void:
    if has_value(key):
        blackboard.erase(key)


