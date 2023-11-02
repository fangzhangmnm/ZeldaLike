@tool
extends CharaState

@export var move_distance:float=5
@export var movement_input:bool=false

func tick()->void:
    super()
    if process_default_transitions():return
    chara.process_grounded_movement(chara.forward*move_distance/anim_time)
    if movement_input:
        chara.rotate_to(chara.input_move)
    if is_anim_finished:transition_to(idle_state);return

func _on_invulnerability_start():
    chara.is_invulnerable=true

func _on_invulnerability_end():
    chara.is_invulnerable=false

func enter(_msg := {}):
    super(_msg)
    chara.anim.anim_invulnerability_start.connect(_on_invulnerability_start)
    chara.anim.anim_invulnerability_end.connect(_on_invulnerability_end)
    if chara.input_move.length()>0:chara.look_at(chara.global_position+chara.input_move)

        
func exit():
    chara.anim.anim_invulnerability_start.disconnect(_on_invulnerability_start)
    chara.anim.anim_invulnerability_end.disconnect(_on_invulnerability_end)
    super()

func _ready():
    wait_for_input_unlock=true