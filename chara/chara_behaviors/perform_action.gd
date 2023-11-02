@tool
class_name CharaBehaviorPerformAction
extends CharaBehaviorNode

@export var action_state_name: String = "Action"
    # set(value):action_state_name=value;validate()

enum FinishBehavior{ANIMATION_END,INPUT_UNLOCK}
@export var finish_on: FinishBehavior = FinishBehavior.ANIMATION_END

@export var need_input_unlock: bool=true
@export var need_towards_target: bool = false
@export var max_target_distance: float=1.2
@export var max_target_angle_deg: float=45

func enter():
    if need_input_unlock and not chara.state.input_unlocked:return FAILURE
    if need_towards_target:
        if chara.target==null:return FAILURE
        if chara.distance_to(chara.target)>max_target_distance:return FAILURE
        if abs(chara.angle_to_deg(chara.target).y)>max_target_angle_deg:return FAILURE
    chara.transition_to(action_state_name)
    return RUNNING


func tick():
    if chara.state.name==action_state_name:
        if finish_on==FinishBehavior.INPUT_UNLOCK and chara.input_unlocked:
            return SUCCESS
        else:
            return RUNNING
    else:
        return SUCCESS

func get_default_name():
    return action_state_name

func validate():
    super()
    if reset_on_failure==false:reset_on_failure=true
    if reset_on_success==false:reset_on_success=true
