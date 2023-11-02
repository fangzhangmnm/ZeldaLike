@tool
extends CharaState

func tick()->void:
    super()
    if process_default_transitions():return
    chara.process_grounded_movement()
    if is_anim_finished:
        transition_to(idle_state)

