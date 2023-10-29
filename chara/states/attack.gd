extends CharaState

@export var anim_name:String

@export var attack_time:float=1
@export var is_jump_attack:bool=false

var canceling_enabled:bool=false
var is_in_attack_window:bool=false
var is_anim_finished:bool=false
    

func physics_update(_delta:float):
    if is_jump_attack:
        if chara.is_on_floor():
            chara.velocity=chara.get_platform_velocity()
        chara.velocity.y-=chara.gravity*_delta
        chara.move_and_slide()

    if is_in_attack_window:
        # attack check
        pass

    if canceling_enabled:
        if process_input():
            return

    if is_anim_finished:
        if is_jump_attack and not chara.is_on_floor():
            pass
        else:
            state_machine.transition_to(on_idle)


func enter(_msg := {}):
    var animation_length=chara.anim.get_animation(anim_name).length
    chara.anim.stop() # to avoid bugs if the same attack animation is still being blended
    chara.anim.play(anim_name,-1,animation_length/attack_time)

    chara.anim_finished.connect(_on_anim_finished)
    chara.anim_event.connect(_on_anim_event)

    canceling_enabled=false
    is_anim_finished=false
    

func exit():
    chara.anim_finished.disconnect(_on_anim_finished)
    chara.anim_event.disconnect(_on_anim_event)

func _on_anim_finished():
    is_anim_finished=true

func _on_anim_event(evt_name:String):
    if evt_name=="enable_canceling":
        canceling_enabled=true
    if evt_name=="attack_start":
        is_in_attack_window=true
    if evt_name=="attack_end":
        is_in_attack_window=false
