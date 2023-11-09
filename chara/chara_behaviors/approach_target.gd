extends CharaBehaviorAction

@export var min_distance:float=1
@export var speed_multiplier:float=1

@export var target_key:StringName="target"

func tick()->Result:
    print("approach_target is deprecated")
    var target=blackboard.get_value(target_key,null)
    if not is_instance_valid(target):return FAILURE
    if not chara.can_perceive(target):return FAILURE
    if chara.distance_to(target)<min_distance:return SUCCESS
    chara.input_move=(target.global_position-chara.global_position).normalized()*speed_multiplier
    return RUNNING

func cleanup():
    chara.input_move=Vector3.ZERO