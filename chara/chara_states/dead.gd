@tool
extends CharaState

@export var remove_time:float=5
var elapsed_time:float=0

func tick()->void:
    super()
    if process_default_transitions():return
    # chara.process_grounded_movement() #TODO character collision is turned off so we can't do that
    elapsed_time+=delta
    if elapsed_time>remove_time:
        if chara.debug_revive:
            chara.current_health=chara.max_health
            chara.current_poise=chara.max_poise
            transition_to(idle_state)
        else:
            chara.queue_free()

func enter(_msg := {}):
    super(_msg)
    chara.configure_dead(true)
    elapsed_time=0

func exit():
    super()
    chara.configure_dead(false)

func _ready():
    wait_for_input_unlock=true
    can_transit_move=false
    can_transit_falling=false
    can_transit_dash=false
    can_transit_jump=false
    can_transit_attack=false
    can_transit_guard=false
    can_transit_knockback=false
    can_be_hit=false