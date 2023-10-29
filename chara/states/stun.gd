extends CharaState

func physics_update(_delta:float)->void:
    if detect_falling():return
    chara.velocity=chara.get_platform_velocity()
    chara.move_and_slide()
    if canceling_enabled:
        if process_input():return
    if is_anim_finished:
        transition_to_idle();return
