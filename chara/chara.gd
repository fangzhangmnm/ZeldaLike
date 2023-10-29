class_name Chara
extends CharacterBody3D

enum InputAction{
	NONE,JUMP,ATTACK,DASH,GUARD
}

var input_move:Vector3=Vector3.ZERO
var input_action_buffed:InputAction=InputAction.NONE
var input_guard_hold:bool=false

@export var speed:float=5 
@export var jump_impulse:float=5
@export var traction:float=10
@export var rotate_speed:float=720
@export var gravity:float=9.8

@onready var anim:AnimationPlayer=%AnimationPlayer
@onready var state_machine:StateMachine=%StateMachine

signal anim_event(evt_name:String)
signal anim_finished

func _on_anim_finished(_anim_name:StringName):
	anim_finished.emit()

func can_jump()->bool:
	return is_on_floor()