@tool
class_name CharaBehaviorPerformAction
extends CharaBehaviorNode

@export var action_state_name: String = "Action"
    # set(value):action_state_name=value;validate()

enum FinishBehavior{ANIMATION_END,INPUT_UNLOCK}
@export var finish_on: FinishBehavior = FinishBehavior.ANIMATION_END

@export var need_towards_target: bool = false
@export var need_input_unlock: bool = true
@export var max_target_distance: float=1.5
@export var max_target_angle_deg: float=45

func enter():
    if need_input_unlock and chara.is_input_unlocked()==false:return FAILURE
    if need_towards_target:
        if chara.input_target==null:return FAILURE
        if chara.distance_to(chara.input_target)>max_target_distance:return FAILURE
        if abs(chara.angle_to_deg(chara.input_target).y)>max_target_angle_deg:return FAILURE
    chara.perform_action(action_state_name,false)
    return RUNNING

func tick():
    if chara.state.name==action_state_name:
        if finish_on==FinishBehavior.INPUT_UNLOCK and chara.is_input_unlocked():
            return SUCCESS
        else:
            return RUNNING
    else:
        return SUCCESS


func validate():
    super()
    if reset_on_failure==false:reset_on_failure=true
    if reset_on_success==false:reset_on_success=true
