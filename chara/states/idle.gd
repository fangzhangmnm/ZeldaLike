extends CharaState

@export var anim_name:String

func physics_update(_delta:float)->void:
    if not chara.is_on_floor():
        state_machine.transition_to(on_fall);return

    chara.velocity=chara.get_platform_velocity()
    chara.move_and_slide()
    process_input()

    

func enter(_msg := {}):
    chara.anim.play(anim_name)
