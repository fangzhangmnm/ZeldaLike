class_name StateMachine
extends Node

# Emitted when transitioning to a new state.
signal transitioned(state_name)



@export var state :State= null # the current state, also used to configure the initial state
enum Tick_Behavior{PROCESS,PHYSICS_PROCESS,EXTERNAL}
@export var tick_behavior:Tick_Behavior=Tick_Behavior.PHYSICS_PROCESS
@export var blackboard:Blackboard
@export var actor:Node
@export var debug_log_transition:bool = false


var delta:float=0.0 # time since last tick

func _ready() -> void:
    if not is_instance_valid(blackboard) and owner.has_node("Blackboard"):
        blackboard=owner.get_node("Blackboard")
    if not is_instance_valid(blackboard) and owner is Blackboard:
        blackboard=owner
    if not is_instance_valid(actor):actor=owner
    for child in get_children():
        child.state_machine = self
    await owner.ready
    state._enter()

func tick(_delta):
    delta=_delta
    state.tick()

func _process(_delta):
    if tick_behavior==Tick_Behavior.PROCESS:
        tick(_delta)

func _physics_process(_delta):
    if tick_behavior==Tick_Behavior.PHYSICS_PROCESS:
        tick(_delta)
    
func transition_to(name_or_state, msg: Dictionary = {}) -> void:
    if name_or_state is String or name_or_state is StringName:
        for child in get_children():
            if child.name.to_lower()==name_or_state.to_lower():
                name_or_state=child
                break
        if name_or_state is String or name_or_state is StringName:
            push_error("Cannot find state with name: ", name_or_state, ".")
            return
    if not name_or_state or not is_instance_valid(name_or_state) or not name_or_state is State:
        push_error("Cannot transition to a null or invalid state.")
        return
    assert(name_or_state.state_machine==self, "Cannot transition to a state that doesn't belong to this state machine.")
    if debug_log_transition and (not "debug_log" in actor or actor.debug_log):
        print(actor.name+": "+state.name+" => "+name_or_state.name)
    state._exit()
    state = name_or_state
    state._enter(msg)
    emit_signal("transitioned", state.name)
