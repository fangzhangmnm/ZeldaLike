extends CharaState

@export var anim_name_left:String
@export var anim_name_right:String
@export var anim_name_back:String

func physics_update(delta:float):
    if detect_falling():return
    
    var look_vector:Vector3 = Vector3.ZERO
    var move_vector:Vector3 = Vector3.ZERO

    if chara.input_lock_on_target:
        look_vector=chara.input_lock_on_target.global_position-chara.global_position
        look_vector.y=0
        move_vector=chara.speed*chara.input_move
    else:
        look_vector=chara.input_move
        move_vector=-chara.basis.z*chara.speed*chara.input_move.length()

    if look_vector.length()>0:
        var rotation_direction = Vector2(-look_vector.z, -look_vector.x).angle()
        chara.rotation.y = lerp_angle(chara.rotation.y, rotation_direction, deg_to_rad(chara.rotate_speed)*delta)

    chara.velocity = chara.velocity.lerp(
        chara.get_platform_velocity()+move_vector, 
        chara.traction*delta)
    
    chara.velocity.y -= chara.gravity*delta
    chara.move_and_slide()

    # the signed angle between look_vector and move_vector on the xz plane
    var angle = rad_to_deg(Vector2(move_vector.x, move_vector.z).angle_to(Vector2(look_vector.x, look_vector.z)))
    if angle>135 or angle<-135:
        chara.anim.play(anim_name_back)
    elif angle>45:
        chara.anim.play(anim_name_left)
    elif angle<-45:
        chara.anim.play(anim_name_right)
    else:
        chara.anim.play(anim_name)


    if process_input():return
    if not is_running():transition_to_idle();return

func is_running()->bool:
    var rel_velocity=chara.velocity-chara.get_platform_velocity()
    return rel_velocity.length()>0.1*chara.speed or chara.input_move.length()>0.1

func enter(_msg := {}):
    super(_msg)
    chara.anim.play(anim_name)
