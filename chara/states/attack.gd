extends CharaState

@export var damage_multiplier:float=1.0
@export var poise_damage_multiplier:float=1.0

@export var is_jump_attack:bool=false
@export var can_attack_multiple:bool=true


@export var align_enemy_threshold_distance:float=2
@export var align_enemy_threshold_deg:float=30

@export var hit_boxes:Array[HitBox]=[]


var attacked_charas:Array[Chara]=[]

func physics_update(_delta:float):
    super(_delta)
    if is_jump_attack:
        if chara.is_on_floor():
            chara.velocity=chara.get_platform_velocity()
            chara.move_and_slide()
        else:
            chara.velocity.y-=chara.gravity*_delta
            chara.move_and_slide()
    else:
        if detect_falling():return

    if canceling_enabled:
        if process_input():return

    if is_anim_finished:
        if is_jump_attack and not chara.is_on_floor():
            pass
        else:
            transition_to_idle();return 

func enter(_msg := {}):
    super(_msg)
    chara.anim.anim_attack_start.connect(_on_attack_start)
    chara.anim.anim_attack_end.connect(_on_attack_end)
    attacked_charas.clear()
    if align_enemy_threshold_deg>0:
        var response=chara.find_nearest_enemy(align_enemy_threshold_deg)
        if response.chara and response.distance<align_enemy_threshold_distance:
            chara.look_at(response.chara.global_position)
            print("align to enemy: "+response.chara.name)
    

func exit():
    disable_hitboxes()
    chara.anim.anim_attack_start.disconnect(_on_attack_start)
    chara.anim.anim_attack_end.disconnect(_on_attack_end)
    super()

func _on_attack_start():
    enable_hitboxes()

func _on_attack_end():
    disable_hitboxes()

func enable_hitboxes():
    for hit_box in hit_boxes:
        hit_box.set_deferred("monitoring",true)
        hit_box.on_hit.connect(_on_attack_hit)

func disable_hitboxes():
    for hit_box in hit_boxes:
        # hit_box.monitoring=false
        hit_box.set_deferred("monitoring",false)
        if hit_box.on_hit.is_connected(_on_attack_hit):
            hit_box.on_hit.disconnect(_on_attack_hit)


func _on_attack_hit(hit:HitBox,hurt:HurtBox):
    if state_machine.debug:
        print("hit: "+(hit.chara.name if hit.chara else hit.name)+" hurt: "+(hurt.chara.name if hurt.chara else hurt.name))

    var msg=HitMessage.new()
    msg.damage=chara.attack_damage*damage_multiplier
    msg.poise_damage=chara.attack_poise_damage*poise_damage_multiplier
    msg.is_blocked=hurt.is_block_box

    if hurt.chara not in attacked_charas:
        attacked_charas.append(hurt.chara)
        if hurt.chara.has_method("on_hit"):
            hurt.chara.on_hit(msg)
    
    if not can_attack_multiple:
        disable_hitboxes()
