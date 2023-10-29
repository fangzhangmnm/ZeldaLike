extends CharaState

@export var anim_name:String

func physics_update(delta:float):
    if not chara.is_on_floor():
        state_machine.transition_to(on_fall);return

    if chara.input_move.length()>0:
        var rotation_direction = Vector2(-chara.input_move.z, -chara.input_move.x).angle()
        chara.rotation.y = lerp_angle(chara.rotation.y, rotation_direction, deg_to_rad(chara.rotate_speed)*delta)

    chara.velocity = chara.velocity.lerp(
        chara.get_platform_velocity()+
        -chara.basis.z*chara.speed*chara.input_move.length(), 
        chara.traction*delta)
    chara.velocity.y -= chara.gravity*delta
    chara.move_and_slide()

    if process_input():
        return
    if not is_running_crietria():
        state_machine.transition_to(on_idle);return

func is_running_crietria()->bool:
    var rel_velocity=chara.velocity-chara.get_platform_velocity()
    return rel_velocity.length()>0.1*chara.speed or chara.input_move.length()>0.1

func enter(_msg := {}):
    chara.anim.play(anim_name)
