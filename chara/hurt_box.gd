class_name HurtBox
extends Area3D
const COLLISION_LAYER_NUMBER:int=11

@onready var chara:Node=owner
@export var is_block_box:bool=false

func is_valid_target(hit:HitBox)->bool:
    if hit.chara and chara and hit.chara==chara:
        return false
    if chara is Chara:
        if chara.is_dead():
            return false
        if chara.is_friendly(hit.chara):
            return false
    return true

func _ready():
    monitoring=false
    collision_layer=1<<COLLISION_LAYER_NUMBER
    collision_mask=0
    if is_block_box:
        monitorable=false
