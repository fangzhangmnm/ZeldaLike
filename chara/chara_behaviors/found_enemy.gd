extends CharaBehaviorCondition

func condition():
    chara.find_nearest_enemy()
    if not is_instance_valid(chara.input_target):return false
    return true

