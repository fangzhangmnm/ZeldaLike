class_name Chara
extends CharacterBody3D


@export_category("Locomotion")
@export var speed:float=5 
@export var jump_impulse:float=5
@export var traction:float=10
@export var rotate_speed:float=720
@export var gravity:float=9.8

@export_category("Combat")


@onready var anim:AnimationPlayer=%AnimationPlayer
@onready var state_machine:CharaStateMachine=%CharaStateMachine



# Input
enum InputAction{
    NONE,JUMP,ATTACK,DASH,GUARD
}
var input_move:Vector3=Vector3.ZERO
var input_action_buffed:InputAction=InputAction.NONE
var input_guard_hold:bool=false
var input_lock_on_target:Node3D=null



func can_jump()->bool:
    return is_on_floor()
func take_damage():
    print("take damage")
    state_machine.state.on_knockback()