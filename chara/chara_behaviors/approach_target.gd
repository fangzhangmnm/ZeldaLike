@tool
extends CharaBehaviorNode

@export var min_distance:float=1
@export var speed_multiplier:float=1

func tick():
    if not is_instance_valid(chara.input_target):return FAILURE
    if not chara.can_perceive(chara.input_target):return FAILURE
    if chara.distance_to(chara.input_target)<min_distance:return SUCCESS
    chara.input_move=(chara.input_target.global_position-chara.global_position).normalized()*speed_multiplier
    return RUNNING