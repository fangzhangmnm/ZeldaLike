class_name StateMachine
extends Node

# Emitted when transitioning to a new state.
signal transitioned(state_name)


@export var state :State= null # the current state, also used to configure the initial state

enum Tick_Behavior{PROCESS,PHYSICS_PROCESS,EXTERNAL}
@export var tick_behavior:Tick_Behavior=Tick_Behavior.PHYSICS_PROCESS

@export_category("Misc")
@export var debug_log_transition:bool = false

var delta:float=0.0 # time since last tick

func _ready() -> void:
    for child in get_children():
        child.state_machine = self
    await owner.ready
    state.enter()

func tick(_delta):
    delta=_delta
    state.tick()

func _process(_delta):
    if tick_behavior==Tick_Behavior.PROCESS:
        tick(_delta)

func _physics_process(_delta):
    if tick_behavior==Tick_Behavior.PHYSICS_PROCESS:
        tick(_delta)
    
func transition_to(target_state: State, msg: Dictionary = {}) -> void:
    assert(target_state!=null, "Cannot transition to a null state.")
    assert(target_state.state_machine==self, "Cannot transition to a state that doesn't belong to this state machine.")
    if debug_log_transition and (not "debug_log" in owner or owner.debug_log):
        printt("Transitioning from ", state.name, " to ", target_state.name)
    state.exit()
    state = target_state
    state.enter(msg)
    emit_signal("transitioned", state.name)
