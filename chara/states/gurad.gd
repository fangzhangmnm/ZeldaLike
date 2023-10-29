extends CharaState

@export var anim_name:String




func physics_update(_delta:float):
    if process_input():
        return
    if not chara.input_guard_hold:
        state_machine.transition_to(on_idle)

            
func enter(_msg := {}):
    chara.anim.play(anim_name)
