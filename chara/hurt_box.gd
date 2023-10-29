class_name HurtBox
extends Area3D
const COLLISION_LAYER_NUMBER:int=10

@onready var chara:Node=owner

func _ready():
    monitoring=false
    collision_layer=1<<COLLISION_LAYER_NUMBER
    collision_mask=0
