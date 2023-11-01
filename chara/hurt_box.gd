class_name HurtBox
extends Area3D
const COLLISION_LAYER_NUMBER:int=11

@onready var chara:Node=owner
@export var is_block_box:bool=false
var enabled:bool=true # do not use ismonitable here because it seems will ignore already overlapped collisions when turned on midway

func _ready():
    monitoring=false
    if is_block_box:
        enabled=false
    collision_layer=1<<COLLISION_LAYER_NUMBER
    collision_mask=0
