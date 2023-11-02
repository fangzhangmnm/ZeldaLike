@tool
extends CharaState

@export var can_move_while_guarding:bool=true
@export var move_speed_multiplier:float=0.5
@export var damage_reduction:float=0.1
@export var poise_damage_reduction:float=0.1

@export var block_boxes:Array[HurtBox]=[]
const is_guard_state=true

func tick():
    super()
    if process_default_transitions():return

    var look_vector:Vector3 = Vector3.ZERO
    var move_vector:Vector3 = Vector3.ZERO

    input_move.y=0
    var move_speed=chara.speed*move_speed_multiplier if can_move_while_guarding else 0.0
    if input_lock_on_target:
        look_vector=input_lock_on_target.global_position-chara.global_position
        move_vector=move_speed*input_move
    else:
        look_vector=chara.input_look
        move_vector=move_speed*input_move
    
    chara.rotate_to(look_vector)
    chara.process_grounded_movement(move_vector)

    for block_box in block_boxes: # do it every frame to avoid bugs
        block_box.monitorable=true
    if not input_guard_hold:transition_to(idle_state);return

func enter(_msg := {}):
    super(_msg)
    for block_box in block_boxes:
        block_box.enabled=true

func exit():
    for block_box in block_boxes:
        block_box.enabled=false
    super()

func _ready():
    can_transit_move=false
    can_transit_guard=false
