extends Node

@onready var camera:CameraController=get_viewport().get_camera_3d().owner as CameraController
@onready var chara:Chara=owner



func _physics_process(_add_constant_forcedelta):
    var input_move_joystick=Input.get_vector("move_left", "move_right", "move_forward", "move_back")
    # project the input vector onto the camera's basis
    var move_vector=camera.global_transform.basis.x*input_move_joystick.x\
                    +camera.global_transform.basis.z*input_move_joystick.y
    move_vector.y=0
    move_vector=move_vector.normalized()*input_move_joystick.length()
    chara.input_move=move_vector
    if Input.is_action_just_pressed("jump"):
        chara.input_action_buffed=Chara.InputAction.JUMP
    if Input.is_action_just_pressed("attack"):
        chara.input_action_buffed=Chara.InputAction.ATTACK
    if Input.is_action_just_pressed("dash"):
        chara.input_action_buffed=Chara.InputAction.DASH
    if Input.is_action_just_pressed("guard"):
        chara.input_action_buffed=Chara.InputAction.GUARD
    chara.input_guard_hold=Input.is_action_pressed("guard")

    if Input.is_action_just_pressed("lock-on"):
        if chara.input_lock_on_target:
            chara.input_lock_on_target=null
            camera.secondary_target=null
        else:
            chara.input_lock_on_target=chara.find_nearest_enemy().chara
            camera.secondary_target=chara.input_lock_on_target
    
    
