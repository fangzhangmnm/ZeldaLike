extends CharaState

@export var movement_input_midair:bool=true

var reference_velocity:Vector3


func physics_update(delta:float):
    if movement_input_midair:
        reference_velocity.y=chara.velocity.y
        chara.velocity = chara.velocity.lerp(
            reference_velocity+chara.speed*chara.input_move,
            chara.traction*delta)
    chara.velocity.y-=chara.gravity*delta
    chara.move_and_slide()

    if process_input():return
    if chara.is_on_floor():transition_to_idle();return

func enter(_msg := {}):
    super(_msg)
    reference_velocity=chara.get_platform_velocity()
    if _msg.has("do_jump"):
        chara.velocity.y+=chara.jump_impulse

