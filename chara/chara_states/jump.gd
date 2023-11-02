extends CharaState

@export var movement_input:bool=true

var reference_velocity:Vector3


func tick():
    super()
    if movement_input:
        reference_velocity.y=chara.velocity.y
        chara.velocity = chara.velocity.lerp(
            reference_velocity+chara.speed*input_move,
            chara.traction*delta)
        if input_move.length()>0: chara.look_at(chara.global_position+input_move)
    chara.velocity.y-=chara.gravity*delta
    chara.move_and_slide()
    
    if process_input():return
    if chara.is_on_floor():transition_to(idle_state);return

func enter(_msg := {}):
    super(_msg)
    reference_velocity=chara.get_platform_velocity()
    if _msg.has("do_jump"):
        chara.velocity.y+=chara.jump_impulse

