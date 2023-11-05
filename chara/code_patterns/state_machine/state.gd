class_name State
extends Node

var state_machine:StateMachine = null
var delta:float:
    get:return state_machine.delta
var blackboard:Node:
    get:return state_machine.blackboard
var actor:Node:
    get:return state_machine.actor
var is_running:bool=false


func tick() -> void:
    pass

func enter(_msg := {}) -> void:
    pass

func exit() -> void:
    pass

func transition_to(target_state: State, msg: Dictionary = {}) -> void:
    state_machine.transition_to(target_state, msg)

func _enter(_msg:={})->void:
    is_running=true
    enter(_msg)

func _exit()->void:
    is_running=false
    exit()