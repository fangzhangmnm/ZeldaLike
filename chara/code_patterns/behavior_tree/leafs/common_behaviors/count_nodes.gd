class_name BehaviorCountNodes
extends BehaviorAction

@export var group_name:StringName=""
@export var output_key:StringName=""

func tick()->Result:
    var count=get_tree().get_nodes_in_group(group_name).size()
    blackboard.set_value(output_key,count)
    return Result.SUCCESS

