class_name CharaBehaviorAction
extends BehaviorAction

var chara:Chara:
    get:return actor as Chara

func start()->void:
    pass

func tick()->Result:
    return SUCCESS

func finish()->void:
    pass

func halt()->void:
    pass

func cleanup()->void: # finish or interrupt
    pass