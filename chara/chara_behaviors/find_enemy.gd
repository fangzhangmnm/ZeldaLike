@tool
extends CharaBehaviorNode

func tick():
    chara.find_nearest_enemy()
    if not is_instance_valid(chara.input_target):return FAILURE
    return SUCCESS

