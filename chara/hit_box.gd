class_name HitBox
extends Area3D

@onready var chara:Node=owner

var overlapped_hurtboxes:Array[HurtBox]=[]
var overlaps_with_block_box:bool=false

func _ready():
    monitoring=true
    collision_layer=0
    collision_mask=1<<HurtBox.COLLISION_LAYER_NUMBER
