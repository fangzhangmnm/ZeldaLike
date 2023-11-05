extends Node

@onready var camera:CameraController=get_viewport().get_camera_3d().owner as CameraController
@onready var chara:Chara=owner

var dash_pressed_time=0.0

@export var long_press_threshold:=0.2

func _physics_process(_delta):
    var input_move_joystick=Input.get_vector("move_left", "move_right", "move_forward", "move_back")
    # project the input vector onto the camera's basis
    var move_vector=camera.global_transform.basis.x*input_move_joystick.x\
                    +camera.global_transform.basis.z*input_move_joystick.y
    move_vector.y=0
    move_vector=move_vector.normalized()*input_move_joystick.length()
    chara.input_move=move_vector
    chara.input_look=-camera.global_transform.basis.z
    if Input.is_action_just_pressed("jump"):
        chara.input_action_buffed=Chara.InputAction.JUMP
    if Input.is_action_just_pressed("attack"):
        chara.input_action_buffed=Chara.InputAction.ATTACK
    if Input.is_action_just_released("dash") and dash_pressed_time<long_press_threshold:
        chara.input_action_buffed=Chara.InputAction.DASH
    if Input.is_action_just_pressed("guard"):
        chara.input_action_buffed=Chara.InputAction.GUARD
    chara.input_guard_hold=Input.is_action_pressed("guard")
    if Input.is_action_just_pressed("dash"):
        dash_pressed_time=0.0
    if Input.is_action_pressed("dash"):
        dash_pressed_time+=_delta
    chara.input_dash_hold=Input.is_action_pressed("dash")


    if Input.is_action_just_pressed("lock-on"):
        if chara.input_target:
            chara.input_target=null
            camera.secondary_target=null
        else:
            chara.input_target=chara.find_nearest_enemy() # todo use a dedicated logic
            camera.secondary_target=chara.input_target

    if chara.input_target is Chara and chara.input_target.is_dead():
        chara.input_target=null
        camera.secondary_target=null

    if chara.input_target:
        chara.input_look=(chara.input_target.global_position-chara.global_position).normalized()

    if chara.debug_cheat:

        if Input.is_action_just_pressed("debug_invisible"):
            chara.perceptible.invisible=not chara.perceptible.invisible
            printt("You are now", "invisible" if chara.perceptible.invisible else "visible")
    
    
