class_name CharaBehaviorCondition
extends BehaviorCondition

var chara:Chara:
    get:return actor as Chara
    
func condition()->bool:
    return true