class_name Chara
extends CharacterBody3D
const COLLISION_LAYER_NUMBER=10
const GROUP_NAME="charas"

@export_category("Locomotion")
@export var speed:float=5 
@export var jump_impulse:float=5
@export var traction:float=10
@export var rotate_speed:float=720
@export var gravity:float=9.8

@export_category("Defensive")
@export var max_health:int=100
@export var current_health:float=100

@export var max_poise:int=50
@export var current_poise:float=50
@export var poise_recovery_delay:float=5
var poise_recovery_delay_timer:float=0

@export_category("Offensive")
@export var attack_damage:int=20
@export var attack_poise_damage:int=10

@export_category("Misc")
@export var faction:String="none"
@export var debug_revive:bool=false
@export var debug_log:bool=false


@onready var anim:CharaAnimationPlayer=%AnimationPlayer
@onready var state_machine:CharaStateMachine=%CharaStateMachine
@onready var perception:Perception=%Perception
@onready var perceptible:Perceptible=%Perceptible


# Player or AI input, will be processed by the state machine
enum InputAction{NONE,JUMP,ATTACK,DASH,GUARD}
var input_look:Vector3=Vector3.ZERO:
    set(value):input_look=value.normalized() if value.length_squared()>0 else Vector3.ZERO
var input_move:Vector3=Vector3.ZERO:
    set(value):input_move=value.limit_length(1)
var input_action_buffed:InputAction=InputAction.NONE
var input_dash_hold:bool=false
var input_guard_hold:bool=false
var input_knockback:bool=false
var input_target:Node3D:
    get:return input_target if is_instance_valid(input_target) else null
    set(value):input_target=value


var is_invulnerable:bool=false


# Utility functions
var forward:Vector3:
    get:return -global_transform.basis.z
var right:Vector3:
    get:return global_transform.basis.x
@onready var delta:float=1.0/Engine.physics_ticks_per_second
var state:CharaState:
    get:return state_machine.state
    set(_value):assert(false,"state is read only")
# func transition_to(name_or_state):
#     state_machine.transition_to(name_or_state)

func can_transit_jump()->bool:
    return is_on_floor() and not is_dead()

func is_input_unlocked()->bool:
    return state.input_unlocked

func is_dead()->bool:
    return state==state_machine.dead_state

func is_friendly(other)->bool:
    return other is Chara and other.faction==faction

func can_be_hit()->bool:
    return not is_dead() and not is_invulnerable and state.can_be_hit

func on_hit(msg:HitMessage):
    if can_be_hit():
        msg.is_blocked = msg.is_blocked and "is_guard_state" in state
        if msg.is_blocked:
            msg.damage*=state.damage_reduction
            msg.poise_damage*=state.poise_damage_reduction
        current_health=clamp(current_health-msg.damage,0,max_health)
        if current_health<=0:
            state.transition_to(state.dead_state);return
        current_poise=clamp(current_poise-msg.poise_damage,0,max_poise)

        if debug_log:
            var word="was hit by" if not msg.is_blocked else "blocks"
            printt(name,word,msg.dealer.name,',takes',msg.damage,'damage and',msg.poise_damage,'poise damage')

        if not msg.is_blocked:
            poise_recovery_delay_timer=poise_recovery_delay
        input_knockback=true

func status_update(_delta:float):
    if not is_dead():
        poise_recovery_delay_timer-=delta
        if poise_recovery_delay_timer<=0:
            current_poise=max_poise

func _physics_process(_delta:float):
    status_update(_delta)

func configure_dead(value:bool):
    if debug_log: printt("configure dead: ",value)
    if value:
        $CapsuleCollider.set_deferred("disabled",true)
    else:
        $CapsuleCollider.set_deferred("disabled",false)

func _ready():
    add_to_group(GROUP_NAME)
    collision_layer=1<<COLLISION_LAYER_NUMBER
    collision_mask=(1<<COLLISION_LAYER_NUMBER)|1




func rotate_to(_look_vector):
    if abs(_look_vector.x)>0 or abs(_look_vector.z)>0:
        var rotation_direction = Vector2(-_look_vector.z, -_look_vector.x).angle()
        rotation.y = lerp_angle(rotation.y, rotation_direction, deg_to_rad(rotate_speed)*delta) #TODO make it linear

func process_grounded_movement(_move_vector:=Vector3.ZERO):
    _move_vector.y=0
    velocity = velocity.lerp(get_platform_velocity()+_move_vector,traction*delta)
    velocity.y -= gravity*delta
    move_and_slide()



func distance_to(_target:Node3D,_transform:=global_transform)->float:
    return perception.distance_to(_target,_transform)
    
func angle_to(_target:Node3D,_transform:=global_transform)->Vector3:
    return perception.angle_to(_target,_transform)

func angle_to_deg(_target:Node3D,_transform:=global_transform)->Vector3:
    return perception.angle_to_deg(_target,_transform)

func find_nearest_enemy():
    var nearest=perception.find_nearest_perceived(
        func(p):
            return not is_friendly(p.owner)
    )
    if is_instance_valid(nearest): input_target = nearest.owner
    if is_instance_valid(input_target) and "perceptible" in input_target and input_target.perceptible not in perception.perceived:
        input_target=null
    # printt(name,"find nearest enemy",input_target)

func can_perceive(_target:Node3D)->bool:
    if not is_instance_valid(_target):return false
    if _target is Perceptible:return _target in perception.perceived
    elif "perceptible" in _target:return _target.perceptible in perception.perceived
    else:return false

func perform_action(action_name,need_input_unlock=true)->bool:
    if is_dead():return false
    if need_input_unlock and not state.input_unlocked:return false
    if debug_log: printt(name,"perform action",action_name)
    state_machine.transition_to(action_name)
    return true


