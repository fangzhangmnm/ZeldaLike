@tool
extends CharaState

@export var dash_speed_multiplier:float=1.5
@export var anim_name_left:String
@export var anim_name_right:String
@export var anim_name_back:String

func tick():
    super()
    if process_default_transitions():return
    
    var look_vector:Vector3 = Vector3.ZERO
    var move_vector:Vector3 = Vector3.ZERO

    var speed=chara.speed
    if chara.input_dash_hold:
        speed*=dash_speed_multiplier

    input_move.y=0
    if input_target:
        look_vector=input_target.global_position-chara.global_position
        move_vector=speed*input_move
    else:
        look_vector=input_move
        move_vector=chara.forward*speed*input_move.length()

    chara.rotate_to(look_vector)
    chara.process_grounded_movement(move_vector)

    var angle = rad_to_deg(Vector2(move_vector.x, move_vector.z).angle_to(Vector2(look_vector.x, look_vector.z)))
    if angle>135 or angle<-135:
        chara.anim.play(anim_name_back)
    elif angle>45:
        chara.anim.play(anim_name_left)
    elif angle<-45:
        chara.anim.play(anim_name_right)
    else:
        chara.anim.play(anim_name)

    if not is_moving():transition_to(idle_state);return

func is_moving()->bool:
    var rel_velocity=chara.velocity-chara.get_platform_velocity()
    return rel_velocity.length()>0.1*chara.speed or input_move.length()>0.1

func enter(_msg := {}):
    super(_msg)
    chara.anim.play(anim_name)
    chara.perceptible.noise_strength=1

func exit():
    chara.perceptible.noise_strength=0
    super()

func _ready():
    can_transit_move=false