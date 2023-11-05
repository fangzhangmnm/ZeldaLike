@icon('./icons/blackboard.svg')
class_name Blackboard
extends Node

@export var blackboard:Dictionary={'default':{}}

func keys()->Array[String]:
    return blackboard.keys().duplicate()

func set_value(key:Variant,value:Variant,scope:String='default')->void:
    if scope not in blackboard:
        blackboard[scope]={}
    blackboard[scope][key]=value

func has_value(key:Variant,scope:String='default')->bool:
    return scope in blackboard and key in blackboard[scope] and blackboard[scope][key]!=null

func get_value(key:Variant,default:Variant=null,scope:String='default')->Variant:
    if has_value(key,scope):
        return blackboard[scope][key]
    return default

func erase_value(key:Variant,scope:String='default')->void:
    if has_value(key,scope):
        blackboard[scope].erase(key)



