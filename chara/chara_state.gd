class_name CharaState
extends State


@export_category("Default State Transition")
@export var on_idle:CharaState
@export var on_fall:CharaState
@export var on_attack_input:CharaState
@export var on_guard_input:CharaState
@export var on_dash_input:CharaState
@export var on_jump_input:CharaState
@export var on_move_input:CharaState

var chara:Chara

func _ready():
    await owner.ready
    chara=owner as Chara
    assert(chara!=null)

func process_input()->bool:
    if on_attack_input and chara.input_action_buffed==chara.InputAction.ATTACK:
        chara.input_action_buffed=chara.InputAction.NONE
        state_machine.transition_to(on_attack_input);return true
    if on_guard_input and chara.input_action_buffed==chara.InputAction.GUARD:
        chara.input_action_buffed=chara.InputAction.NONE
        state_machine.transition_to(on_guard_input);return true
    if on_dash_input and chara.input_action_buffed==chara.InputAction.DASH:
        chara.input_action_buffed=chara.InputAction.NONE
        state_machine.transition_to(on_dash_input);return true
    if on_jump_input and chara.input_action_buffed==chara.InputAction.JUMP and chara.can_jump():
        chara.input_action_buffed=chara.InputAction.NONE
        state_machine.transition_to(on_jump_input,{do_jump=true});return true
    if on_move_input and chara.input_move.length()>0:
        state_machine.transition_to(on_move_input);return true
    return false

