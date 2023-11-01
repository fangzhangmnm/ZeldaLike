extends CharaState

@export var damage_reduction:float=0.1
@export var poise_damage_reduction:float=0.1

@export var block_boxes:Array[HurtBox]=[]
const is_guard_state=true

func physics_update(_delta:float):
    super(_delta)
    if detect_falling():return
    chara.velocity=chara.get_platform_velocity()
    chara.move_and_slide()
    for block_box in block_boxes:
        block_box.monitorable=true
    if process_input():return
    if not input_guard_hold:transition_to(idle_state);return

func enter(_msg := {}):
    super(_msg)
    for block_box in block_boxes:
        block_box.enabled=true

func exit():
    for block_box in block_boxes:
        block_box.enabled=false
    super()