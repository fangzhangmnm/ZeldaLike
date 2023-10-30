# https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/



# Generic state machine. Initializes states and delegates engine callbacks
# (_physics_process, _unhandled_input) to the active state.
class_name StateMachine
extends Node

# Emitted when transitioning to a new state.
signal transitioned(state_name)

# The current active state. At the start of the game, we get the `initial_state`.
@export var state :State= null
@export var debug:bool = false


func _ready() -> void:
    # The state machine assigns itself to the State objects' state_machine property.
    for child in get_children():
        child.state_machine = self
    await owner.ready # wait for the owner to be ready
    state.elapsed_physics_time = 0
    state.enter()


# The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
    state.handle_input(event)


func _process(delta: float) -> void:
    state.update(delta)


func _physics_process(delta: float) -> void:
    state.elapsed_physics_time += delta
    state.physics_update(delta)


# This function calls the current state's exit() function, then changes the active state,
# and calls its enter function.
# It optionally takes a `msg` dictionary to pass to the next state's enter() function.
func transition_to(target_state: State, msg: Dictionary = {}) -> void:
    assert(target_state!=null, "Cannot transition to a null state.")
    assert(target_state.state_machine==self, "Cannot transition to a state that doesn't belong to this state machine.")
    if debug:
        print("Transitioning from ", state.name, " to ", target_state.name)
    state.exit()
    state = target_state
    state.elapsed_physics_time = 0
    state.enter(msg)
    emit_signal("transitioned", state.name)
