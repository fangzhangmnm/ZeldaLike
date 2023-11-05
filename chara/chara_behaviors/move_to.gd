extends CharaBehaviorAction

@export var min_distance:=0.5
@export var speed_multiplier:=0.5
@export var speed_coeff:=1.
@export var position_or_node_key:String="target"

func tick()->Result:
    var position=blackboard.get_value(position_or_node_key)
    if not is_instance_valid(position) and not (position is Vector3): return FAILURE
    if position is Node3D: position = position.global_position
    if chara.distance_to(position)<min_distance: return SUCCESS
    var input_move=speed_multiplier*(position-chara.global_position)*speed_coeff
    input_move=input_move.limit_length(speed_multiplier)
    chara.input_move=input_move
    return RUNNING

func cleanup():
    chara.input_move=Vector3.ZERO