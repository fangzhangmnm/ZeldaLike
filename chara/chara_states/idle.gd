extends CharaState

func tick()->void:
    super()
    if detect_falling(): return
    chara.velocity=chara.get_platform_velocity()
    chara.move_and_slide()
    if process_input(): return

