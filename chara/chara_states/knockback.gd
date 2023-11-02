extends CharaState


func tick()->void:
    super()
    if detect_falling():return
    chara.velocity=chara.get_platform_velocity()
    chara.move_and_slide()
    if canceling_enabled:
        if process_input():return
    if is_anim_finished:
        transition_to(idle_state);return