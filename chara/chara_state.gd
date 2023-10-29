class_name CharaState
extends State

@export_category("Animation and Length")
@export var anim_name:String=""
@export var anim_time:float=-1
@export var anim_fade:bool=true

@export_category("Default State Transition Behavior")
@export var can_move:bool=true
@export var can_fall:bool=true
@export var can_jump:bool=true
@export var can_attack:bool=true
@export var can_guard:bool=true
@export var can_knockback:bool=true

@export_category("Default State Override")
@export var idle_state_override:CharaState=null
@export var move_state_override:CharaState=null
@export var fall_state_override:CharaState=null
@export var jump_state_override:CharaState=null
@export var attack_state_override:CharaState=null
@export var guard_state_override:CharaState=null
@export var knockback_state_override:CharaState=null


var idle_state:CharaState:
    get:return idle_state_override if idle_state_override else state_machine.idle_state
var move_state:CharaState:
    get:return move_state_override if move_state_override else state_machine.move_state
var fall_state:CharaState:
    get:return fall_state_override if fall_state_override else state_machine.fall_state
var jump_state:CharaState:
    get:return jump_state_override if jump_state_override else state_machine.jump_state
var attack_state:CharaState:
    get:return attack_state_override if attack_state_override else state_machine.attack_state
var guard_state:CharaState:
    get:return guard_state_override if guard_state_override else state_machine.guard_state
var knockback_state:CharaState:
    get:return knockback_state_override if knockback_state_override else state_machine.knockback_state

var input_move:Vector3:
    get:return chara.input_move
    set(value):chara.input_move=value
var input_action_buffed:Chara.InputAction:
    get:return chara.input_action_buffed
    set(value):chara.input_action_buffed=value
var input_guard_hold:bool:
    get:return chara.input_guard_hold
    set(value):chara.input_guard_hold=value
var input_lock_on_target:Node3D:
    get:return chara.input_lock_on_target
    set(value):chara.input_lock_on_target=value


@onready var chara:Chara=owner as Chara
var canceling_enabled:bool=false
var is_anim_finished:bool=false

func process_input()->bool:
    if can_attack and input_action_buffed==Chara.InputAction.ATTACK:
        input_action_buffed=Chara.InputAction.NONE
        transition_to(attack_state);return true
    if can_guard and input_guard_hold and state_machine.state!=guard_state:
        input_action_buffed=Chara.InputAction.NONE
        transition_to(guard_state);return true
    if can_jump and input_action_buffed==Chara.InputAction.JUMP and chara.can_jump():
        input_action_buffed=Chara.InputAction.NONE
        transition_to(jump_state,{do_jump=true});return true
    if can_move and input_move.length()>0 and state_machine.state!=move_state and state_machine.state!=jump_state:
        transition_to(move_state);return true
    return false


func detect_falling()->bool:
    if can_fall and not chara.is_on_floor() and state_machine.state!=fall_state:
        transition_to(fall_state);return true
    return false

func transition_to_idle():
    transition_to(idle_state)

func on_knockback():
    if can_knockback:
        transition_to(knockback_state)


func _physics_process(delta):
    if chara.anim.current_animation!=anim_name:
        is_anim_finished=true

func enter(_msg:={}):
    canceling_enabled=false
    is_anim_finished=false
    chara.anim.anim_enable_canceling.connect(_on_enable_canceling)
    chara.anim.anim_finished.connect(_on_anim_finished)
    if anim_name!="":
        if not anim_fade:
            pass
            # chara.anim.stop(true)
        if anim_time>0:
            var animation_length=chara.anim.get_animation(anim_name).length
            chara.anim.play(anim_name,-1,animation_length/anim_time)
        else:
            chara.anim.play(anim_name)

func exit():
    chara.anim.anim_finished.disconnect(_on_anim_finished)
    chara.anim.anim_enable_canceling.disconnect(_on_enable_canceling)

func _on_anim_finished():
    is_anim_finished=true

func _on_enable_canceling():
    canceling_enabled=true
