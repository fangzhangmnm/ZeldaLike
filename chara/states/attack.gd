extends CharaState

@export var is_jump_attack:bool=false

@export var hit_boxes:Array[HitBox]=[]

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
    var name1=hit.name
    if hit.chara: name1=hit.chara.name
    var name2=hurt.name
    if hurt.chara: name2=hurt.chara.name
    print("hit: "+name1+" hurt: "+name2)
    if hurt.chara and hurt.chara is Chara:
        hurt.chara.take_damage()

    disable_hitboxes()
