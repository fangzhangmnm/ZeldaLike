class_name State
extends Node

var state_machine:StateMachine = null
var delta:float:
    get:return state_machine.delta
var blackboard:Node:
    get:return state_machine.blackboard


func tick() -> void:
    pass


func enter(_msg := {}) -> void:
    pass

func exit() -> void:
    pass

func transition_to(target_state: State, msg: Dictionary = {}) -> void:
    state_machine.transition_to(target_state, msg)
