@tool
extends CharaState


func tick()->void:
    super()
    if process_default_transitions():return
    chara.process_grounded_movement() # TODO knock vector
    if is_anim_finished:
        transition_to(idle_state);return

func _ready():
    wait_for_input_unlock=true