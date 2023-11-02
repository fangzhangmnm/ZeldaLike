@tool
extends CharaState

@export_category("Attack Stats")
@export var damage_multiplier:float=1.0
@export var poise_damage_multiplier:float=1.0

@export_category("Attack Behavior")
@export var is_jump_attack:bool=false
@export var can_attack_multiple:bool=true
@export var move_amount:Vector2=Vector2(0,0)
@export var align_enemy:bool=false
@export var align_enemy_threshold_distance:float=2
@export var align_enemy_threshold_deg:float=45
@export var align_enemy_rotation_bias:float=0

@export_category("Attack Audio")
@export var swing_sound:AudioStream
@export var hit_sound:AudioStream
@export var blocked_sound:AudioStream

@export var hit_boxes:Array[HitBox]=[]

var is_blocked:bool=false
var already_attacked_charas:Array[Chara]=[]
var is_attack_enabled:bool=false

func tick():
    super()
    if process_default_transitions():return

    if is_jump_attack:
        if chara.is_on_floor():
            chara.process_grounded_movement()
        else:
            chara.velocity.y-=chara.gravity*delta
            chara.move_and_slide()
    else:
        chara.process_grounded_movement((chara.right*move_amount.x+chara.forward*move_amount.y)/anim_time)

    if is_attack_enabled:
        process_attack()

    if is_anim_finished:
        if is_jump_attack and not chara.is_on_floor():
            pass
        else:
            transition_to(idle_state);return 

func process_attack():
    var overlapped_hurtboxes:Array[HurtBox]=[]
    for hit_box in hit_boxes:
        for hurt_box in hit_box.get_overlapping_areas():
            if hurt_box is HurtBox:
                if is_valid_target(hurt_box):
                    overlapped_hurtboxes.append(hurt_box)
                    if hurt_box.is_block_box:
                        is_blocked=true
    for hurt_box in overlapped_hurtboxes:
        process_attack_hit(hurt_box)

func is_valid_target(hurt:HurtBox)->bool:
    if not hurt.enabled: return false
    if hurt.chara and hurt.chara==chara: return false
    if hurt.chara is Chara:
        if hurt.chara.is_dead(): return false
        if not hurt.chara.can_be_hit(): return false
        if hurt.chara.is_friendly(chara): return false
    if not hurt.chara.has_method("on_hit"): return false
    return true
    
func process_attack_hit(hurt:HurtBox):
    if not is_attack_enabled: return
    if hurt.chara in already_attacked_charas: return
    if chara.debug_log: 
        var word="hits" if not is_blocked else "was blocked by"
        printt(chara.name,word,(hurt.chara.name if hurt.chara else hurt.name))
    already_attacked_charas.append(hurt.chara)

    var sound=hit_sound if not is_blocked else blocked_sound
    if audio_source and sound:
        audio_source.stream=sound
        audio_source.play()

    var msg=HitMessage.new()
    msg.dealer=chara
    msg.damage=chara.attack_damage*damage_multiplier
    msg.poise_damage=chara.attack_poise_damage*poise_damage_multiplier
    msg.is_blocked=is_blocked

    hurt.chara.on_hit(msg)

    if not can_attack_multiple:
        is_attack_enabled=false



func enter(_msg := {}):
    super(_msg)
    chara.anim.anim_attack_start.connect(_on_attack_start)
    chara.anim.anim_attack_end.connect(_on_attack_end)
    already_attacked_charas.clear()
    is_attack_enabled=false
    is_blocked=false
    if align_enemy and chara.input_target:
        if chara.distance_to(chara.input_target)<align_enemy_threshold_distance:
            if abs(chara.angle_to(chara.input_target).y)<align_enemy_threshold_deg:
                chara.look_at(input_target.global_position)
                chara.rotation_degrees.y+=align_enemy_rotation_bias
    

func exit():
    chara.anim.anim_attack_start.disconnect(_on_attack_start)
    chara.anim.anim_attack_end.disconnect(_on_attack_end)
    super()

func _on_attack_start():
    already_attacked_charas.clear()
    is_attack_enabled=true
    is_blocked=false
    if audio_source and swing_sound:
        audio_source.stream=swing_sound
        audio_source.play()

func _on_attack_end():
    is_attack_enabled=false

func _ready():
    wait_for_input_unlock=true
    if is_jump_attack:can_transit_falling=false

