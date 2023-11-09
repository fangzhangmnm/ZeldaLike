extends CharaBehaviorAction

@export var store_target_key:StringName="target"
@export var store_position_key:StringName="last_seen_position"
@export var lock_on_target:bool=true

func tick():
    var target=blackboard.get_value(store_target_key)
    target=chara.find_nearest_enemy()
    if not is_instance_valid(target):
        if lock_on_target:chara.input_target=null
        return FAILURE
    blackboard.set_value(store_target_key,target)
    blackboard.set_value(store_position_key,target.global_position)
    if lock_on_target:chara.input_target=target
    return SUCCESS

