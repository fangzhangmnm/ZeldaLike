extends CharaState


func physics_update(_delta:float):
    super(_delta)
    if detect_falling():return
    chara.velocity=chara.get_platform_velocity()
    chara.move_and_slide()
    if process_input():return
    if not input_guard_hold:transition_to_idle();return

            