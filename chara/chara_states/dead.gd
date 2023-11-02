extends CharaState

@export var remove_time:float=5
var elapsed_time:float=0

func tick()->void:
    super()
    # if chara.is_on_floor():
    #     chara.velocity=chara.get_platform_velocity()
    # else:
    #     chara.velocity.y-=chara.gravity*_delta
    # chara.move_and_slide()
    elapsed_time+=delta
    if elapsed_time>remove_time:
        if chara.debug_revive:
            chara.current_health=chara.max_health
            chara.current_poise=chara.max_poise
            transition_to(idle_state)
        else:
            chara.queue_free()

func enter(_msg := {}):
    super(_msg)
    chara.configure_dead(true)
    elapsed_time=0

func exit():
    super()
    chara.configure_dead(false)
