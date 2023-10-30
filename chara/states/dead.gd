extends CharaState

@export var remove_time:float=10

func physics_update(_delta:float)->void:
    super(_delta)
    # if chara.is_on_floor():
    #     chara.velocity=chara.get_platform_velocity()
    # else:
    #     chara.velocity.y-=chara.gravity*_delta
    # chara.move_and_slide()

    if elapsed_physics_time>remove_time:
        if chara.debug_revive:
            chara.current_health=chara.max_health
            chara.current_poise=chara.max_poise
            transition_to_idle()
        chara.queue_free()

func enter(_msg := {}):
    super(_msg)
    chara.configure_dead(true)

func exit():
    super()
    chara.configure_dead(false)