extends Node

@export var camera:Node3D
@onready var chara:Chara=self.owner

func _ready():
    if camera==null:
        camera=get_viewport().get_camera_3d()

func _physics_process(_add_constant_forcedelta):
    var input_move=Input.get_vector("move_left", "move_right", "move_forward", "move_back")
    # project the input vector onto the camera's basis
    var move_vector=camera.global_transform.basis.x*input_move.x\
                    +camera.global_transform.basis.z*input_move.y
    move_vector.y=0
    move_vector=move_vector.normalized()*input_move.length()
    chara.input_move=move_vector
    if Input.is_action_just_pressed("jump"):
        chara.input_action_buffed=chara.InputAction.JUMP
    if Input.is_action_just_pressed("attack"):
        chara.input_action_buffed=chara.InputAction.ATTACK
    if Input.is_action_just_pressed("dash"):
        chara.input_action_buffed=chara.InputAction.DASH
    if Input.is_action_just_pressed("guard"):
        chara.input_action_buffed=chara.InputAction.GUARD
    chara.input_guard_hold=Input.is_action_pressed("guard")
    
    
