extends CharaState

@export var move_distance:float=5
@export var movement_input:bool=false

func physics_update(_delta:float)->void:
    super(_delta)
    if detect_falling(): return
    chara.velocity=chara.get_platform_velocity()
    if movement_input:
        if chara.input_move.length()>0:chara.look_at(chara.global_position+chara.input_move)
    chara.velocity+=-chara.global_transform.basis.z*move_distance/anim_time
    chara.move_and_slide()
    if is_anim_finished:
        transition_to(idle_state)

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