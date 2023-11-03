@tool
class_name CharaBehaviorPerformAction
extends CharaBehaviorAction

@export var action_state_name: String = "Action"
    # set(value):action_state_name=value;validate()

enum FinishBehavior{ANIMATION_END,INPUT_UNLOCK}
@export var finish_on: FinishBehavior = FinishBehavior.ANIMATION_END

@export var need_towards_target: bool = false
@export var need_input_unlock: bool = true
@export var max_target_distance: float=1.5
@export var max_target_angle_deg: float=45

var has_action_started: bool = false

func start():
    has_action_started=false
    if need_input_unlock and chara.is_input_unlocked()==false:return
    if need_towards_target:
        if chara.input_target==null:return
        if chara.distance_to(chara.input_target)>max_target_distance:return
        if abs(chara.angle_to_deg(chara.input_target).y)>max_target_angle_deg:return
    if chara.perform_action(action_state_name,false):has_action_started=true

func tick()->Result:
    if not has_action_started:return FAILURE
    if chara.state.name==action_state_name:
        if finish_on==FinishBehavior.INPUT_UNLOCK and chara.is_input_unlocked():
            return SUCCESS
        else:
            return RUNNING
    else:
        return SUCCESS


