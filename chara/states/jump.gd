extends CharaState

@export var anim_name:String

@export var can_move:bool=true

var reference_velocity:Vector3


func physics_update(delta:float):
    if can_move:
        reference_velocity.y=chara.velocity.y
        chara.velocity = chara.velocity.lerp(
            reference_velocity+chara.speed*chara.input_move,
            chara.traction*delta)
    chara.velocity.y-=chara.gravity*delta
    chara.move_and_slide()

    if process_input():
        return

    if chara.is_on_floor():
        state_machine.transition_to(on_idle);return

func enter(_msg := {}):
    reference_velocity=chara.get_platform_velocity()
    if _msg.has("do_jump"):
        chara.velocity.y+=chara.jump_impulse
    chara.anim.play(anim_name)