@tool
extends CharaState

@export var movement_input:bool=true

var reference_velocity:Vector3


func tick():
    super()
    if process_default_transitions():return
    if movement_input:
        reference_velocity.y=chara.velocity.y
        chara.velocity = chara.velocity.lerp(
            reference_velocity+chara.speed*input_move,
            chara.traction*delta)
        chara.rotate_to(chara.velocity)
    chara.velocity.y-=chara.gravity*delta
    chara.move_and_slide()
    if chara.is_on_floor():transition_to(idle_state);return

func enter(_msg := {}):
    super(_msg)
    reference_velocity=chara.get_platform_velocity()
    if _msg.has("do_jump"):
        chara.velocity.y+=chara.jump_impulse

func _ready():
    can_transit_move=false
    can_transit_falling=false
    
    
    
    
    