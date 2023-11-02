class_name CharaState
extends State

@export_category("Animation and Length")
@export var anim_name:String=""
@export var anim_time:float=-1
@export var anim_fade:bool=true

@export_category("Audio and Effects")
@export var start_sound:AudioStream=null
@export var audio_source:AudioStreamPlayer3D=null

@export_category("Default State Behavior")
@export var can_move:bool=true
@export var will_fall:bool=true
@export var can_dash:bool=true
@export var can_jump:bool=true
@export var can_attack:bool=true
@export var can_guard:bool=true
@export var can_be_knockback:bool=true
@export var can_be_hit:bool=true

@export_category("Default State Override")
@export var idle_state_override:CharaState=null
var idle_state:CharaState:
    get:return idle_state_override if idle_state_override else state_machine.idle_state
@export var move_state_override:CharaState=null
var move_state:CharaState:
    get:return move_state_override if move_state_override else state_machine.move_state
@export var fall_state_override:CharaState=null
var fall_state:CharaState:
    get:return fall_state_override if fall_state_override else state_machine.fall_state
@export var dash_state_override:CharaState=null
var dash_state:CharaState:
    get:return dash_state_override if dash_state_override else state_machine.dash_state
@export var jump_state_override:CharaState=null
var jump_state:CharaState:
    get:return jump_state_override if jump_state_override else state_machine.jump_state
@export var attack_state_override:CharaState=null
var attack_state:CharaState:
    get:return attack_state_override if attack_state_override else state_machine.attack_state
@export var guard_state_override:CharaState=null
var guard_state:CharaState:
    get:return guard_state_override if guard_state_override else state_machine.guard_state
@export var knockback_state_override:CharaState=null
var knockback_state:CharaState:
    get:return knockback_state_override if knockback_state_override else state_machine.knockback_state
@export var stagger_state_override:CharaState=null
var stagger_state:CharaState:
    get:return stagger_state_override if stagger_state_override else state_machine.stagger_state
@export var dead_state_override:CharaState=null
var dead_state:CharaState:
    get:return dead_state_override if dead_state_override else state_machine.dead_state

# expose chara variables for convenience

@onready var chara:Chara=owner as Chara

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

# common conditional variables shared by the inherited states

var canceling_enabled:bool=false
var is_anim_finished:bool=false

# common routines shared by the inherited states

func process_input()->bool:
    if can_dash and input_action_buffed==Chara.InputAction.DASH:
        input_action_buffed=Chara.InputAction.NONE
        transition_to(dash_state);return true
    if can_attack and input_action_buffed==Chara.InputAction.ATTACK:
        input_action_buffed=Chara.InputAction.NONE
        transition_to(attack_state);return true
    if can_guard and input_guard_hold and self!=guard_state:
        input_action_buffed=Chara.InputAction.NONE
        transition_to(guard_state);return true
    if can_jump and input_action_buffed==Chara.InputAction.JUMP and chara.can_jump():
        input_action_buffed=Chara.InputAction.NONE
        transition_to(jump_state,{do_jump=true});return true
    if can_move and input_move.length()>0 and self!=move_state and self!=jump_state:
        transition_to(move_state);return true
    return false


func detect_falling()->bool:
    if will_fall and not chara.is_on_floor() and self!=fall_state:
        transition_to(fall_state);return true
    return false

func on_knockback():
    if can_be_knockback:
        if chara.current_poise<=0:
            chara.poise_recovery_delay_timer=.2
            transition_to(stagger_state)
        else:
            transition_to(knockback_state)

# common routines for tick, enter, exit. Remember to call super() if you override them

func tick():
    if chara.anim.current_animation!=anim_name:
        is_anim_finished=true

func enter(_msg:={}):
    canceling_enabled=false
    is_anim_finished=false
    chara.anim.anim_enable_canceling.connect(_on_enable_canceling)
    chara.anim.anim_finished.connect(_on_anim_finished)
    
    if audio_source and start_sound:
        audio_source.stream=start_sound
        audio_source.play()

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

# function handles


func _on_anim_finished():
    is_anim_finished=true

func _on_enable_canceling():
    canceling_enabled=true